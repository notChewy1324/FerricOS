#!/usr/bin/env bash
# PHASE 5: build all PKGBUILDs, update the pacman repo db, push to GitHub Releases.
# Requires: base-devel, github-cli (gh auth login), a GPG key for signing.
set -euo pipefail
cd "$(dirname "$0")/.."
REPO_TAG="packages"          # fixed release tag that acts as the pacman repo
DB="ferric.db.tar.gz"
STAGING="$PWD/local-repo"
mkdir -p "$STAGING"

for d in pkgbuilds/*/; do
  echo "[ferric] building ${d}"
  ( cd "$d" && makepkg -f --sign )
  mv "$d"/*.pkg.tar.zst "$d"/*.pkg.tar.zst.sig "$STAGING"/ 2>/dev/null || true
done

cd "$STAGING"
repo-add --sign "$DB" ./*.pkg.tar.zst
echo "[ferric] uploading to GitHub release '$REPO_TAG'"
gh release create "$REPO_TAG" --notes "FerricOS pacman repo" 2>/dev/null || true
gh release upload "$REPO_TAG" ./* --clobber
echo "[ferric] pacman repo updated. Server URL:"
echo "  https://github.com/notChewy1324/ferricos/releases/download/$REPO_TAG"
