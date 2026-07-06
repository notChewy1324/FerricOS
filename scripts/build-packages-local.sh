#!/usr/bin/env bash
# Package dev loop: build every PKGBUILD into ./local-repo and
# point profile/pacman.conf's [ferric] block at it (file://). Run this on an
# Arch box as a NORMAL USER (makepkg refuses root) before ./scripts/build-iso.sh.
# Flip to the GitHub Server URL only when publishing (publish-packages.sh).
set -euo pipefail
cd "$(dirname "$0")/.."
REPO_ROOT="$PWD"
STAGING="$REPO_ROOT/local-repo"
DB="ferric.db.tar.gz"

mkdir -p "$STAGING"

for d in pkgbuilds/*/; do
  pkg="$(basename "$d")"
  if [[ "$pkg" == "ferric-keyring" && ! -f "$d/ferric.gpg" ]]; then
    echo "[ferric] SKIP $pkg (no key material yet — see pkgbuilds/ferric-keyring/README.md)"
    continue
  fi
  echo "[ferric] building $pkg"
  # calamares is the only PKGBUILD that compiles: -s pulls its makedepends.
  # The rest are meta/file-only packages whose depends include ferric-* and
  # calamares — not in any repo until these very builds are published — so
  # skip build-time dep checks (-d); depends still land in .PKGINFO.
  if [[ "$pkg" == "calamares" ]]; then
    ( cd "$d" && makepkg -f -s --noconfirm )
  else
    ( cd "$d" && makepkg -f -d --noconfirm )
  fi
  mv "$d"/*.pkg.tar.zst "$STAGING"/
done

cd "$STAGING"
repo-add -R "$DB" ./*.pkg.tar.zst

# Wire profile/pacman.conf's managed [ferric] block at this local repo.
wire_block="[ferric]
SigLevel = Optional TrustAll
Server = file://$STAGING"
python3 - "$REPO_ROOT/profile/pacman.conf" "$wire_block" << 'EOF'
import sys, re
path, block = sys.argv[1], sys.argv[2]
text = open(path).read()
new = re.sub(r'(# FERRIC-REPO-BEGIN\n).*?(# FERRIC-REPO-END)',
             r'\1' + block + '\n' + r'\2', text, flags=re.S)
open(path, 'w').write(new)
EOF

echo "[ferric] local repo ready at $STAGING"
echo "[ferric] profile/pacman.conf [ferric] now points at file://$STAGING"
echo "[ferric] next: ./scripts/build-iso.sh"
