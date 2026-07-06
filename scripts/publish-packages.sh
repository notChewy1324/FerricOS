#!/usr/bin/env bash
# PHASE 5: build all PKGBUILDs, update the pacman repo db, push to the fixed
# `packages` GitHub release, and wire BOTH pacman.confs at the GitHub URL.
# Requires: base-devel, github-cli (gh auth login). Run as a normal user.
# Signing: pass --sign once ferric-keyring key material exists.
set -euo pipefail
cd "$(dirname "$0")/.."
REPO_ROOT="$PWD"
REPO_TAG="packages"          # fixed release tag that acts as the pacman repo
DB="ferric.db.tar.gz"
STAGING="$REPO_ROOT/local-repo"
SERVER_URL="https://github.com/notChewy1324/ferricos/releases/download/$REPO_TAG"

SIGN=0
[[ "${1:-}" == "--sign" ]] && SIGN=1

mkdir -p "$STAGING"

for d in pkgbuilds/*/; do
  pkg="$(basename "$d")"
  if [[ "$pkg" == "ferric-keyring" && ! -f "$d/ferric.gpg" ]]; then
    echo "[ferric] SKIP $pkg (no key material yet — see pkgbuilds/ferric-keyring/README.md)"
    continue
  fi
  echo "[ferric] building $pkg"
  if (( SIGN )); then
    ( cd "$d" && makepkg -f -s --noconfirm --sign )
    mv "$d"/*.pkg.tar.zst "$d"/*.pkg.tar.zst.sig "$STAGING"/
  else
    ( cd "$d" && makepkg -f -s --noconfirm )
    mv "$d"/*.pkg.tar.zst "$STAGING"/
  fi
done

cd "$STAGING"
if (( SIGN )); then
  repo-add -R --sign "$DB" ./*.pkg.tar.zst
else
  repo-add -R "$DB" ./*.pkg.tar.zst
fi

# GitHub release assets cannot be symlinks: repo-add
# leaves ferric.db / ferric.files as symlinks, so stage real copies.
UPLOAD_DIR="$(mktemp -d)"
cp -L ferric.db "$UPLOAD_DIR/ferric.db"
cp -L ferric.files "$UPLOAD_DIR/ferric.files"

echo "[ferric] uploading to GitHub release '$REPO_TAG'"
gh release create "$REPO_TAG" --title "FerricOS package repo" \
  --notes "Rolling pacman repo. Server = $SERVER_URL" 2>/dev/null || true
gh release upload "$REPO_TAG" ./*.pkg.tar.zst --clobber
if (( SIGN )); then
  gh release upload "$REPO_TAG" ./*.sig --clobber
fi
gh release upload "$REPO_TAG" "$DB" ferric.files.tar.gz \
  "$UPLOAD_DIR/ferric.db" "$UPLOAD_DIR/ferric.files" --clobber
rm -rf "$UPLOAD_DIR"

# Wire BOTH pacman.confs (build-time + runtime) at the GitHub URL.
for conf in "$REPO_ROOT/profile/pacman.conf" "$REPO_ROOT/profile/airootfs/etc/pacman.conf"; do
  python3 - "$conf" "$SERVER_URL" << 'EOF'
import sys, re
path, url = sys.argv[1], sys.argv[2]
block = f"[ferric]\nSigLevel = Optional TrustAll\nServer = {url}"
text = open(path).read()
new = re.sub(r'(# FERRIC-REPO-BEGIN\n).*?(# FERRIC-REPO-END)',
             r'\1' + block + '\n' + r'\2', text, flags=re.S)
open(path, 'w').write(new)
EOF
done

echo "[ferric] published. Both pacman.confs now point at:"
echo "  $SERVER_URL"
echo "[ferric] rebuild + boot-test the ISO next."
