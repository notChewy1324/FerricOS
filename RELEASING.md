# Releasing FerricOS

The release procedure, start to finish. Two artifacts exist: the **package
repo** (fixed `packages` release, a pacman repo) and **ISO releases**
(versioned `vYYYY.MM.DD` tags). Packages first, always — the ISO consumes
them.

## 0. Preconditions

- Working tree clean, `main` pushed.
- On an Arch box: `archiso base-devel qemu-full edk2-ovmf github-cli` and
  `gh auth login` done.
- `pacman -Sy archlinux-keyring` recent (stale keys are the #1 build failure).

## 1. Publish packages

Any push touching `pkgbuilds/**` on `main` runs
`.github/workflows/build-packages.yml`, which rebuilds every package,
regenerates `ferric.db` (uploaded as real files — release assets must not
be symlinks), and clobbers the `packages` release assets.

Manual alternative from an Arch box:

```bash
./scripts/publish-packages.sh          # unsigned (pre-keyring)
./scripts/publish-packages.sh --sign   # once ferric-keyring key material exists
```

Verify the repo really serves:

```bash
sudo tee -a /etc/pacman.conf << 'EOF'
[ferric]
SigLevel = Optional TrustAll
Server = https://github.com/notChewy1324/ferricos/releases/download/packages
EOF
sudo pacman -Sy && pacman -Si ferric-base
```

(The CI workflow does this same smoke test as its last step.)

## 2. Build + verify the ISO

CI path: GitHub → Actions → "Build FerricOS ISO" → Run workflow. It wires
`[ferric]` at the packages release, builds, and publishes `vYYYY.MM.DD`
with `SHA256SUMS`. This also happens automatically on the 1st of each month.

Local path:

```bash
./scripts/build-packages-local.sh   # or skip if testing published packages
./scripts/build-iso.sh
```

**Mandatory QEMU checks, BOTH boot modes** (`./scripts/test-bios.sh`,
`./scripts/test-uefi.sh`):

- [ ] syslinux menu is ferric-themed (BIOS); systemd-boot text menu (UEFI)
- [ ] boots to greetd → autologin into Hyprland as `ferric`
- [ ] waybar, kitty (`ff` shows the ferric logo), fuzzel, mako all themed
- [ ] `pacman -Qi ferric-base` works; `cat /etc/os-release` says FerricOS
- [ ] `ferric-wall` cycles all four oxide wallpapers (Super+Shift+W)
- [ ] Super+L locks (hyprlock, flat dark field)

**Install tests** (QEMU + blank virtual disk, BIOS and UEFI):

- [ ] Calamares "Install FerricOS": plain ext4, btrfs, and LUKS runs
- [ ] `ferric-install` (archinstall) run
- [ ] each install reboots into: GRUB ferric theme → Plymouth tape-spool
      splash (LUKS prompt themed) → tuigreet → Hyprland, all in palette
- [ ] on the installed system: `/etc/os-release` = FerricOS,
      `pacman -Syu` clean, `[ferric]` + `[multilib]` active

## 3. Real-hardware pass (before announcing anything)

USB-boot at least one BIOS and one UEFI machine (Secure Boot off): keyboard,
Wi-Fi (`iwctl` / nmtui), display, install + reboot. NVIDIA box if available
(nvidia-dkms path).

## 4. Tag & announce

The ISO workflow already created `vYYYY.MM.DD` with `SHA256SUMS`. Edit the
release notes: what changed, known issues, the Secure Boot caveat, and the
package-repo state (signed or TrustAll).

## Keyring milestone (one-time, when ready)

1. Drop key material into `pkgbuilds/ferric-keyring/` (see its README).
2. Publish packages, install `ferric-keyring` everywhere.
3. Flip both pacman.confs' `[ferric]` SigLevel to `Required DatabaseOptional`
   (they're the FERRIC-REPO-BEGIN/END blocks; also update the two scripts and
   both workflows that write those blocks).
4. Start publishing with `--sign`, and add the key-import step + secrets to
   `build-packages.yml` / `build-iso.yml`.
