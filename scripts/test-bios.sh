#!/usr/bin/env bash
# Boot-test the newest ISO in BIOS mode.
set -euo pipefail
cd "$(dirname "$0")/.."
ISO="$(ls -t out/*.iso | head -1)"
echo "[ferric] BIOS boot: $ISO"
qemu-system-x86_64 -m 6G -enable-kvm -vga virtio -display sdl,gl=on -cdrom "$ISO"
