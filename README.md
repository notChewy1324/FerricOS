# FerricOS

> **FerricOS is designed & built by Cam Garrison.**
> An Arch-based distribution with a cassette-futurism soul — magnetic tape, sodium light, and a terminal that glows.

FerricOS is a rolling-release Arch Linux derivative built with [archiso](https://wiki.archlinux.org/title/Archiso). This repository is the entire distro: the ISO recipe, the package sources, and the build automation.

## Repository layout

```
ferricos/
├── profile/            # archiso profile — the ISO recipe (based on releng)
│   ├── airootfs/       # files overlaid onto the live filesystem
│   ├── packages.x86_64 # every package on the ISO, one per line
│   ├── profiledef.sh   # ISO identity + build settings
│   └── grub/ efiboot/ syslinux/   # boot menus
├── pkgbuilds/          # sources for ferric-* packages (Phase 5)
├── scripts/            # build, test, and publish helpers
└── .github/workflows/  # automated monthly ISO builds
```

## Building

On an up-to-date Arch system with `archiso`, `qemu-full`, and `edk2-ovmf`:

```bash
./scripts/build-iso.sh     # ISO lands in ./out/
./scripts/test-bios.sh     # boot it in QEMU (BIOS)
./scripts/test-uefi.sh     # boot it in QEMU (UEFI)
```

The build pulls the latest packages from the Arch mirrors at build time — the recipe is evergreen, the ISO is a snapshot.

> Secure Boot is not yet supported. Disable it when testing on real hardware.

## How updates flow

- **Installed systems** track Arch's official repos directly via `pacman -Syu` — kernel, desktop, everything.
- **FerricOS-specific packages** (`ferric-base`, `ferric-artwork`, …) ship from this repo's `packages` release, which acts as the pacman repo. See `scripts/publish-packages.sh`.
- **ISOs** are rebuilt monthly by CI and published under versioned releases. An ISO is only a delivery vehicle for new installs.

## Status

Early development — currently a branded releng profile. Desktop stack, live user, theming, and installer to follow.

## Credits

Built on [Arch Linux](https://archlinux.org) and [archiso](https://gitlab.archlinux.org/archlinux/archiso). FerricOS is an independent personal project and is not affiliated with or endorsed by Arch Linux.

## License

GPL-3.0-or-later. The `profile/` directory is derived from [archiso](https://gitlab.archlinux.org/archlinux/archiso)'s releng configuration (GPL-3.0-or-later); FerricOS additions are released under the same terms.
