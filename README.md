<div align="center">

```text
┌──────────────────────────────────────────────────────────────┐
│ ◯                                                          ◯ │
│   ╭──────────────────────────────────────────────────────╮   │
│   │                   F E R R I C O S                    │   │
│   │         an arch-based distribution · side A          │   │
│   ╰──────────────────────────────────────────────────────╯   │
│        (●)        ▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮        (●)        │
│    Fe₂O₃ · MAGNETIC TAPE · SODIUM LIGHT · ROLLING RELEASE    │
│ ◯                ▄▄            ▄▄            ▄▄            ◯ │
└──────────────────────────────────────────────────────────────┘
```

**FerricOS is designed & built by Cam Garrison.**
An Arch-based distribution with a cassette-futurism soul — magnetic tape, sodium light, and a quiet terminal.

[![ISO build](https://img.shields.io/github/actions/workflow/status/notChewy1324/FerricOS/build-iso.yml?style=flat-square&label=iso%20build&labelColor=0C0B0A)](https://github.com/notChewy1324/FerricOS/actions/workflows/build-iso.yml)
[![packages](https://img.shields.io/github/actions/workflow/status/notChewy1324/FerricOS/build-packages.yml?style=flat-square&label=packages&labelColor=0C0B0A)](https://github.com/notChewy1324/FerricOS/actions/workflows/build-packages.yml)
[![latest ISO](https://img.shields.io/github/v/release/notChewy1324/FerricOS?style=flat-square&label=latest%20iso&labelColor=0C0B0A&color=D85A30)](https://github.com/notChewy1324/FerricOS/releases)
[![base](https://img.shields.io/badge/base-arch%20linux-D8AE5B?style=flat-square&labelColor=0C0B0A)](https://archlinux.org)
[![license](https://img.shields.io/badge/license-GPL--3.0--or--later-544C44?style=flat-square&labelColor=0C0B0A)](LICENSE)

<samp>[install](#-installing) · [build](#-building) · [layout](#-repository-layout) · [updates](#-how-updates-flow) · [palette](#-palette)</samp>

</div>

<!-- hero screenshot placeholder — capture the live Hyprland desktop with
     waybar + fastfetch on the oxide wallpaper, save as docs/screenshot-hero.png,
     then uncomment:
![FerricOS desktop](docs/screenshot-hero.png)
-->

FerricOS is a rolling-release Arch Linux derivative built with [archiso](https://wiki.archlinux.org/title/Archiso). This repository is the entire distro: the ISO recipe, the `ferric-*` package sources, and the build automation. Nothing lives anywhere else — clone it and you hold the whole machine.

## <samp>// spec sheet</samp>

| &nbsp; | &nbsp; |
|---|---|
| **Base** | Arch Linux, rolling release, AUR-compatible |
| **Compositor** | Hyprland — 1px seams, no blur, no glow |
| **Bar / launcher / notifications** | waybar · fuzzel · mako |
| **Terminal** | kitty |
| **Boot chain** | syslinux → Plymouth tape-spool splash → tuigreet, one continuous instrument-panel look |
| **Installers** | `ferric-install` (preseeded archinstall, terminal) · *Install FerricOS* (Calamares, graphical; ext4 / btrfs / LUKS) |
| **Identity** | a handful of `ferric-*` packages served from this repo's own pacman repo, `[ferric]` |

## <samp>// features</samp>

- **Quiet Ferric desktop** — Hyprland + waybar + kitty + fuzzel + mako, tuned to one palette (oxide `#D85A30` on near-black `#0C0B0A`), 1px seams, no blur, no glow.
- **Continuous boot chain** — syslinux menu, Plymouth tape-spool splash, tuigreet, and desktop share the same instrument-panel look.
- **Two installers** — `ferric-install` (preseeded archinstall, terminal) and *Install FerricOS* (Calamares, graphical; ext4 / btrfs / LUKS).
- **Real Arch underneath** — pacman, AUR-compatible, rolling. The distro identity travels in a handful of `ferric-*` packages from this repo's own pacman repo.
- **Everything reproducible** — this repo builds the ISO and every package, locally or in CI.

## <samp>// installing</samp>

1. Grab the latest ISO from [Releases](https://github.com/notChewy1324/FerricOS/releases) and verify it against `SHA256SUMS`.
2. Write it to a USB stick:
   ```bash
   sudo dd if=ferricos-*.iso of=/dev/sdX bs=4M status=progress oflag=sync
   ```
   (Or just drop the ISO onto a [Ventoy](https://www.ventoy.net) stick.)

> [!IMPORTANT]
> **Disable Secure Boot** — it is not yet supported.

3. Boot the stick (BIOS or UEFI). The live session logs straight into Hyprland as the `ferric` user.
4. Install with either:
   - **Install FerricOS** (app launcher → Calamares), or
   - `ferric-install` in a terminal (archinstall, preseeded with the FerricOS set).

## <samp>// building</samp>

On an up-to-date Arch system with `archiso`, `base-devel`, `qemu-full`, and `edk2-ovmf`:

```bash
./scripts/build-packages-local.sh   # build ferric-* into ./local-repo and wire [ferric]
./scripts/build-iso.sh              # ISO lands in ./out/
./scripts/test-bios.sh              # boot it in QEMU (BIOS)
./scripts/test-uefi.sh              # boot it in QEMU (UEFI)
```

The build pulls the latest packages from the Arch mirrors at build time — **the recipe is evergreen, the ISO is a snapshot.**

## <samp>// repository layout</samp>

```text
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

## <samp>// how updates flow</samp>

```text
installed system ──── pacman -Syu ────────────────► Arch official repos
                └──── pacman -Syu ────────────────► [ferric] repo
                                                        ▲
push to pkgbuilds/** ──► CI ──► repo-add ──► fixed `packages` release

monthly timer ──► CI ──► archiso ──► versioned ISO release ──► new installs only
```

- **Installed systems** track Arch's official repos directly via `pacman -Syu` — kernel, desktop, everything.
- **FerricOS-specific packages** (`ferric-base`, `ferric-skel`, `ferric-artwork`, …) ship from this repo's fixed `packages` release, which is a real pacman repo (`[ferric]`). Pushing to `pkgbuilds/**` republishes it via CI.
- **ISOs** are rebuilt monthly by CI and published under versioned releases. An ISO is only a delivery vehicle for new installs — existing systems never need to reinstall.

## <samp>// palette</samp>

Every surface — boot menu, splash, greeter, desktop — draws from one ferrous swatch card:

![oxide](https://img.shields.io/badge/oxide-%23D85A30-D85A30?style=flat-square&labelColor=0C0B0A)
![rust](https://img.shields.io/badge/rust-%23C14A3A-C14A3A?style=flat-square&labelColor=0C0B0A)
![sodium](https://img.shields.io/badge/sodium-%23D8AE5B-D8AE5B?style=flat-square&labelColor=0C0B0A)
![paper](https://img.shields.io/badge/paper-%23E8DCC8-E8DCC8?style=flat-square&labelColor=0C0B0A)
![bone](https://img.shields.io/badge/bone-%23C9BFB2-C9BFB2?style=flat-square&labelColor=0C0B0A)
![sediment](https://img.shields.io/badge/sediment-%23544C44-544C44?style=flat-square&labelColor=0C0B0A)
![substrate](https://img.shields.io/badge/substrate-%232E2A26-2E2A26?style=flat-square&labelColor=0C0B0A)
![coal](https://img.shields.io/badge/coal-%2311100E-11100E?style=flat-square&labelColor=544C44)
![black](https://img.shields.io/badge/black-%230C0B0A-0C0B0A?style=flat-square&labelColor=544C44)

## <samp>// credits</samp>

Built on [Arch Linux](https://archlinux.org) and [archiso](https://gitlab.archlinux.org/archlinux/archiso). Installer flow modeled on [EndeavourOS](https://endeavouros.com)'s Calamares setup. FerricOS is an independent personal project and is not affiliated with or endorsed by Arch Linux.

All code and design are by Cam Garrison.

> [!NOTE]
> **Forks must rename**: "FerricOS", the wordmark, and the artwork identify this project — derivative distros should ship their own name and branding.

## <samp>// license</samp>

GPL-3.0-or-later. The `profile/` directory is derived from [archiso](https://gitlab.archlinux.org/archlinux/archiso)'s releng configuration (GPL-3.0-or-later); FerricOS additions are released under the same terms.

---

<div align="center">
<samp>◄◄ &nbsp; ▐▐ &nbsp; ►► &nbsp;·&nbsp; tape counter [ 0 0 0 0 ] &nbsp;·&nbsp; Fe₂O₃ on polyester, since 2026</samp>
</div>
