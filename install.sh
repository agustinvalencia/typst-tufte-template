#!/bin/bash

set -e

# Install this template as a local Typst package, so documents can use
#   #import "@local/<name>:<version>": *
#
# Usage:
#   ./install.sh          copy the package into the local package dir (for end users)
#   ./install.sh --link   symlink this repo instead, so edits take effect live (for development)

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Detect OS and set the Typst local package directory
if [[ "$OSTYPE" == "darwin"* ]]; then
  BASE_DIR="$HOME/Library/Application Support/typst/packages/local"
elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" || "$OSTYPE" == "win32" ]]; then
  BASE_DIR="${APPDATA}/typst/packages/local"
else
  BASE_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/typst/packages/local"
fi

# Read name and version straight from the manifest so they never drift
NAME=$(grep -E '^name'    "$REPO_DIR/typst.toml" | head -1 | sed 's/.*=//; s/[" ]//g')
VERSION=$(grep -E '^version' "$REPO_DIR/typst.toml" | head -1 | sed 's/.*=//; s/[" ]//g')

if [[ -z "$NAME" || -z "$VERSION" ]]; then
  echo "❌ Could not read name/version from typst.toml" >&2
  exit 1
fi

TARGET="$BASE_DIR/$NAME/$VERSION"

# Clear any prior install (real dir or symlink) so we start clean
rm -rf "$TARGET"
mkdir -p "$BASE_DIR/$NAME"

if [[ "$1" == "--link" ]]; then
  ln -sfn "$REPO_DIR" "$TARGET"
  echo "🔗 Linked $NAME:$VERSION -> $REPO_DIR"
else
  mkdir -p "$TARGET"
  cp "$REPO_DIR/typst.toml" "$REPO_DIR/tufte.typ" "$TARGET/"
  [[ -f "$REPO_DIR/LICENSE" ]] && cp "$REPO_DIR/LICENSE" "$TARGET/"
  [[ -f "$REPO_DIR/README.md" ]] && cp "$REPO_DIR/README.md" "$TARGET/"
  echo "📦 Installed $NAME:$VERSION -> $TARGET"
fi

echo ""
echo "✅ Done. Use it with:"
echo "  #import \"@local/$NAME:$VERSION\": *"
echo "  typst init @local/$NAME:$VERSION my-document"
