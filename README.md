# FerricOS

> **FerricOS is designed & built by Cam Garrison.**
> An Arch-based distribution with a cassette-futurism soul — magnetic tape, sodium light, and a quiet terminal.

<!-- hero screenshot placeholder — capture the live Hyprland desktop with
     waybar + fastfetch on the oxide wallpaper, save as docs/screenshot-hero.png,
     then uncomment:
![FerricOS desktop](docs/screenshot-hero.png)
-->


FerricOS is a rolling-release Arch Linux derivative built with [archiso](https://wiki.archlinux.org/title/Archiso). This repository is the entire distro: the ISO recipe, the `ferric-*` package sources, and the build automation.

## Features

- **Quiet Ferric desktop** — Hyprland + waybar + kitty + fuzzel + mako, tuned to one palette (oxide `#D85A30` on near-black `#0C0B0A`), 1px seams, no blur, no glow.
- **Continuous boot chain** — syslinux menu, Plymouth tape-spool splash, tuigreet, and desktop share the same instrument-panel look.
- **Two installers** — `ferric-install` (preseeded archinstall, terminal) and *Install FerricOS* (Calamares, graphical; ext4 / btrfs / LUKS).
- **Real Arch underneath** — pacman, AUR-compatible, rolling. The distro identity travels in a handful of `ferric-*` packages from this repo's own pacman repo.
- **Everything reproducible** — this repo builds the ISO and every package, locally or in CI.

## Installing

1. Grab the latest ISO from [Releases](https://github.com/notChewy1324/ferricos/releases) and verify it against `SHA256SUMS`.
2. Write it to a USB stick:
   ```bash
   sudo dd if=ferricos-*.iso of=/dev/sdX bs=4M status=progress oflag=sync
   ```
   (Or just drop the ISO onto a [Ventoy](https://www.ventoy.net) stick.)
3. **Disable Secure Boot** — it is not yet supported.
4. Boot the stick (BIOS or UEFI). The live session logs straight into Hyprland as the `ferric` user.
5. Install with either:
   - **Install FerricOS** (app launcher → Calamares), or
   - `ferric-install` in a terminal (archinstall, preseeded with the FerricOS set).

## Repository layout

```
ferricos/
├── profile/            # archiso profile — the ISO recipe (based on releng)
│   ├── airootfs/       # LIVE-SESSION-ONLY overlay (never reaches installs)
│   ├── packages.x86_64 # every package on the ISO, one per line
│   ├── profiledef.sh   # ISO identity + build settings
│   └── grub/ efiboot/ syslinux/   # boot menus
├── pkgbuilds/          # sources for ferric-* packages + calamares
├── scripts/            # build, test, and publish helpers
└── .github/workflows/  # package publishing + monthly ISO builds
```

## Building

On an up-to-date Arch system with `archiso`, `base-devel`, `qemu-full`, and `edk2-ovmf`:

```bash
./scripts/build-packages-local.sh   # build ferric-* into ./local-repo and wire [ferric]
./scripts/build-iso.sh              # ISO lands in ./out/
./scripts/test-bios.sh              # boot it in QEMU (BIOS)
./scripts/test-uefi.sh              # boot it in QEMU (UEFI)
```

The build pulls the latest packages from the Arch mirrors at build time — the recipe is evergreen, the ISO is a snapshot.

## How updates flow

- **Installed systems** track Arch's official repos directly via `pacman -Syu` — kernel, desktop, everything.
- **FerricOS-specific packages** (`ferric-base`, `ferric-skel`, `ferric-artwork`, …) ship from this repo's fixed `packages` release, which is a real pacman repo (`[ferric]`). Pushing to `pkgbuilds/**` republishes it via CI.
- **ISOs** are rebuilt monthly by CI and published under versioned releases. An ISO is only a delivery vehicle for new installs — existing systems never need to reinstall.

## Credits

Built on [Arch Linux](https://archlinux.org) and [archiso](https://gitlab.archlinux.org/archlinux/archiso). Installer flow modeled on [EndeavourOS](https://endeavouros.com)'s Calamares setup. FerricOS is an independent personal project and is not affiliated with or endorsed by Arch Linux.

All code and design are by Cam Garrison.

**Forks must rename**: "FerricOS", the wordmark, and the artwork identify this project — derivative distros should ship their own name and branding.

## License

GPL-3.0-or-later. The `profile/` directory is derived from [archiso](https://gitlab.archlinux.org/archlinux/archiso)'s releng configuration (GPL-3.0-or-later); FerricOS additions are released under the same terms.
