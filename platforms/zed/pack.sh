#!/bin/sh
# Pack the Zed theme extension into an installable zip.
# A Zed theme is pure resources (extension.toml + themes/*.json), so nothing
# is compiled. The zip holds a "vesper-golden/" folder with the extension
# layout Zed expects for a dev extension.
#
# Output goes to the repo-root builds/ directory. Prints the final zip path.
set -e
cd "$(dirname "$0")"                 # platforms/zed
ROOT="$(cd ../.. && pwd)"

NAME="vesper-golden"                 # extension folder name inside the zip (== extension id)

# Single source of truth for the version: the "version" field in extension.toml.
VERSION="$(sed -n 's/^version[[:space:]]*=[[:space:]]*"\([^"]*\)".*/\1/p' extension.toml | head -1)"
[ -n "$VERSION" ] || { echo "pack.sh: no version in extension.toml" >&2; exit 1; }

OUTDIR="$ROOT/builds"
OUT="$OUTDIR/vesper-golden-zed-$VERSION.zip"
mkdir -p "$OUTDIR"

# Stage the "vesper-golden/" layout in a temp dir so nothing is left behind.
STAGE="$(mktemp -d)"
trap 'rm -rf "$STAGE"' EXIT
mkdir -p "$STAGE/$NAME/themes"
cp extension.toml "$STAGE/$NAME/"
cp themes/vesper-golden.json "$STAGE/$NAME/themes/"

rm -f "$OUT"
( cd "$STAGE" && zip -r -q "$OUT" "$NAME" )

echo "$OUT"
