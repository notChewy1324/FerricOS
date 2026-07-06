#!/usr/bin/env bash
# Build the FerricOS ISO. Run on an up-to-date Arch system with archiso installed.
set -euo pipefail
cd "$(dirname "$0")/.."

WORK_DIR="${WORK_DIR:-/home/ferricos-work}"
OUT_DIR="${OUT_DIR:-$PWD/out}"

# packages.x86_64 pulls ferric-base, so the [ferric] repo must be wired in
# (build-packages-local.sh for the dev loop, publish-packages.sh for GitHub).
if grep -q '^ferric-base$' profile/packages.x86_64 \
   && ! grep -q '^\[ferric\]' profile/pacman.conf; then
  echo "[ferric] ERROR: packages.x86_64 needs ferric-base but profile/pacman.conf"
  echo "         has no active [ferric] repo. Run ./scripts/build-packages-local.sh first."
  exit 1
fi

echo "[ferric] updating keyring (stale keys are the #1 build failure)"
sudo pacman -Sy --noconfirm archlinux-keyring

echo "[ferric] wiping work dir: $WORK_DIR"
sudo rm -rf "$WORK_DIR"

echo "[ferric] building ISO -> $OUT_DIR"
sudo mkarchiso -v -w "$WORK_DIR" -o "$OUT_DIR" ./profile

echo "[ferric] done:"
ls -lh "$OUT_DIR"/*.iso
