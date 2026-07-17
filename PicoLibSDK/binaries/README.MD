# Picopad binaries

The full SD card image and the UF2 tree are no longer committed to this
repository. They are published as **GitHub Release assets** instead, kept
in sync with [`Panda381/PicoLibSDK/!PicoPad10/`](https://github.com/Panda381/PicoLibSDK/tree/main/!PicoPad10) upstream.

The loose `UF2/` directory in this folder is still kept for now (used by
external links such as the Pajeníčko website) and will be removed in a
follow-up once those links are switched to release URLs.

## Where to download

- Latest release: https://github.com/Pajenicko/Picopad/releases/latest
- All releases:   https://github.com/Pajenicko/Picopad/releases

Each release contains:

| Asset                       | Contents                                                |
|-----------------------------|---------------------------------------------------------|
| `picopad-sdcard.zip`        | Full SD-card image (UF2 + assets, ready to extract)     |
| `picopad-uf2-tree.tar.gz`   | UF2 tree preserving `DEMO/`, `EMU/`, `GAME/` etc.       |
| Individual `*.UF2`          | Direct download for flashing a single game / demo       |
| `manifest.json`             | Upstream commit pinned to this build                    |

## Stable URLs

For per-game UF2 downloads from automation or web tools, use the **latest**
release pseudo-tag, which always redirects to the most recent build:

```
https://github.com/Pajenicko/Picopad/releases/latest/download/MULTISET.UF2
https://github.com/Pajenicko/Picopad/releases/latest/download/picopad-sdcard.zip
```

## Updating the binaries

The binaries are produced from `Panda381/PicoLibSDK/!PicoPad10/`. To pull
fresh binaries into a new release, run the **Sync binaries from upstream
PicoLibSDK** workflow on GitHub Actions (Actions tab → "Run workflow"), or
locally:

```bash
./scripts/sync-binaries.sh
```

The workflow also runs automatically once a week (Mondays 04:00 UTC).

## Default Picopad image

The default image for Picopad is `MULTISET.UF2`, also available at
`https://github.com/Pajenicko/Picopad/releases/latest/download/MULTISET.UF2`.

## Preparing the SD card

Download `picopad-sdcard.zip` from the latest release and extract its
contents to the root of an SD card formatted as FAT32 (or FAT16/FAT12 for
very small cards).
