#!/usr/bin/env bash
# Boot-test the newest ISO in UEFI mode (requires edk2-ovmf).
set -euo pipefail
cd "$(dirname "$0")/.."
ISO="$(ls -t out/*.iso | head -1)"
OVMF="/usr/share/edk2/x64/OVMF_CODE.4m.fd"
[[ -f "$OVMF" ]] || OVMF="/usr/share/edk2-ovmf/x64/OVMF_CODE.fd"
echo "[ferric] UEFI boot: $ISO"
qemu-system-x86_64 -m 6G -enable-kvm -vga virtio -display sdl,gl=on -cdrom "$ISO" \
  -drive if=pflash,format=raw,readonly=on,file="$OVMF"
