#!/usr/bin/env bash
#
# Sync the !PicoPad10 binaries from upstream Panda381/PicoLibSDK into a
# GitHub Release on this repository.
#
# What it does:
#   1. Shallow-clone https://github.com/Panda381/PicoLibSDK
#   2. Re-archive '!PicoPad10/SDCARD/' into picopad-sdcard.zip
#   3. Collect every .UF2 from '!PicoPad10/UF2/' into a flat tarball
#      so individual files can be downloaded directly from the Release.
#   4. Create (or update) a GitHub Release tagged "binaries-${DATE}" and
#      upload the artifacts plus a manifest.json describing what's in it.
#
# Usage:
#   ./scripts/sync-binaries.sh                    # auto-pick tag from date
#   TAG=binaries-2026.05 ./scripts/sync-binaries.sh
#
# Requirements: git, zip, jq, gh (authenticated with write access to this repo).

set -euo pipefail

UPSTREAM_URL="https://github.com/Panda381/PicoLibSDK.git"
UPSTREAM_DIR="!PicoPad10"
TAG="${TAG:-binaries-$(date +%Y.%m.%d)}"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

echo "==> Cloning $UPSTREAM_URL (shallow) into $WORK"
git clone --depth=1 "$UPSTREAM_URL" "$WORK/upstream"

UPSTREAM_REV="$(cd "$WORK/upstream" && git rev-parse HEAD)"
UPSTREAM_REV_SHORT="$(cd "$WORK/upstream" && git rev-parse --short HEAD)"
echo "    upstream HEAD: $UPSTREAM_REV"

SRC="$WORK/upstream/$UPSTREAM_DIR"
[ -d "$SRC" ] || { echo "ERROR: $UPSTREAM_DIR not found in upstream"; exit 1; }

OUT="$WORK/release"
mkdir -p "$OUT"

# 1) SD card archive
if [ -d "$SRC/SDCARD" ]; then
  echo "==> Packaging SDCARD/ -> picopad-sdcard.zip"
  ( cd "$SRC" && zip -qr "$OUT/picopad-sdcard.zip" SDCARD )
fi

# 2) Loose UF2 files (flat) — keep filenames so per-game URLs work.
if [ -d "$SRC/UF2" ]; then
  echo "==> Copying loose UF2 binaries"
  while IFS= read -r -d '' f; do
    cp -p "$f" "$OUT/$(basename "$f")"
  done < <(find "$SRC/UF2" -type f -name '*.UF2' -print0)
  # And a tarball of the full UF2 tree (preserves DEMO/EMU/GAME structure).
  ( cd "$SRC" && tar -czf "$OUT/picopad-uf2-tree.tar.gz" UF2 )
fi

# 3) Manifest
echo "==> Writing manifest.json"
ASSET_LIST=$(cd "$OUT" && find . -type f -printf '%P\t%s\n' | sort)
cat > "$OUT/manifest.json" <<JSON
{
  "tag": "${TAG}",
  "generated_at_utc": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "upstream": {
    "repo": "Panda381/PicoLibSDK",
    "subtree": "${UPSTREAM_DIR}",
    "rev": "${UPSTREAM_REV}",
    "rev_short": "${UPSTREAM_REV_SHORT}"
  }
}
JSON

# 4) Create / update release
echo "==> Publishing release '$TAG'"
NOTES_FILE="$WORK/notes.md"
cat > "$NOTES_FILE" <<MD
Binaries synced from [Panda381/PicoLibSDK](${UPSTREAM_URL}) \`${UPSTREAM_DIR}/\`,
upstream commit \`${UPSTREAM_REV_SHORT}\`.

Assets:
- \`picopad-sdcard.zip\` — full SD card image
- \`picopad-uf2-tree.tar.gz\` — UF2 tree (DEMO/EMU/GAME/...)
- Loose \`*.UF2\` files for direct flashing

See \`manifest.json\` for the upstream commit pinned to this build.
MD

if gh release view "$TAG" >/dev/null 2>&1; then
  echo "    release exists, replacing assets"
  ( cd "$OUT" && gh release upload "$TAG" * --clobber )
  gh release edit "$TAG" --notes-file "$NOTES_FILE"
else
  ( cd "$OUT" && gh release create "$TAG" \
      --title "Picopad binaries ${TAG#binaries-}" \
      --notes-file "$NOTES_FILE" \
      * )
fi

echo "==> Done. Release: $(gh release view "$TAG" --json url -q .url)"
