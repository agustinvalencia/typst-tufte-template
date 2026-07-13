#!/bin/bash

set -e

# Remove this template from the local Typst package directory.
# Mirrors install.sh: same OS detection, same name/version from the manifest.

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ "$OSTYPE" == "darwin"* ]]; then
  BASE_DIR="$HOME/Library/Application Support/typst/packages/local"
elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" || "$OSTYPE" == "win32" ]]; then
  BASE_DIR="${APPDATA}/typst/packages/local"
else
  BASE_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/typst/packages/local"
fi

NAME=$(grep -E '^name'    "$REPO_DIR/typst.toml" | head -1 | sed 's/.*=//; s/[" ]//g')
VERSION=$(grep -E '^version' "$REPO_DIR/typst.toml" | head -1 | sed 's/.*=//; s/[" ]//g')

if [[ -z "$NAME" || -z "$VERSION" ]]; then
  echo "❌ Could not read name/version from typst.toml" >&2
  exit 1
fi

TARGET="$BASE_DIR/$NAME/$VERSION"

if [[ ! -e "$TARGET" && ! -L "$TARGET" ]]; then
  echo "ℹ️  $NAME:$VERSION is not installed ($TARGET not found). Nothing to do."
  exit 0
fi

rm -rf "$TARGET"
echo "🗑️  Removed $NAME:$VERSION from $TARGET"

# Drop the now-empty name directory (leave it if other versions remain)
rmdir "$BASE_DIR/$NAME" 2>/dev/null && echo "   (removed empty $BASE_DIR/$NAME)" || true

echo "✅ Uninstalled."
