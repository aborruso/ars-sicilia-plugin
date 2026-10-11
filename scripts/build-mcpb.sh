#!/usr/bin/env bash
# Costruisce dist/ars-sicilia.mcpb: il server MCP e la CLI di ars-sicilia per
# Windows (amd64) e macOS (binario universale arm64 + amd64).
#
# Il server lancia la CLI per eseguire gli strumenti e la cerca prima nella sua
# stessa cartella, quindi il bundle porta entrambi i binari in bin/.
#
# Uso: scripts/build-mcpb.sh [cartella-sorgente-della-cli]
set -euo pipefail

SRC="${1:-$HOME/printing-press/library/ars-sicilia}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
BUILD="$ROOT/build/mcpb"
DIST="$ROOT/dist"
MAKEFAT="github.com/randall77/makefat@v0.0.0-20260406194835-1b91746796b7"
MCPB="@anthropic-ai/mcpb@2.1.2"

[ -f "$SRC/go.mod" ] || { echo "sorgente della CLI non trovato in $SRC" >&2; exit 1; }

# La versione del bundle e' quella della CLI; se il sorgente non coincide col
# rilascio (commit successivi al tag) si aggiunge il commit, perche' un bundle
# costruito da main non e' quel rilascio.
VERSION="$(sed -n 's/^var version = "\(.*\)"/\1/p' "$SRC/internal/cli/root.go")"
SHA="$(git -C "$SRC" rev-parse --short HEAD)"
VERSION="$VERSION-local.$SHA"

rm -rf "$BUILD"
mkdir -p "$BUILD/bin" "$BUILD/tmp" "$DIST"

export CGO_ENABLED=0 GOTOOLCHAIN=auto
build() { # goos goarch cmd out
  (cd "$SRC" && GOOS="$1" GOARCH="$2" go build -trimpath -ldflags "-s -w" -o "$4" "./cmd/$3")
}
for cmd in ars-sicilia-pp-mcp ars-sicilia-pp-cli; do
  build windows amd64 "$cmd" "$BUILD/bin/$cmd.exe"
  build darwin arm64 "$cmd" "$BUILD/tmp/$cmd-arm64"
  build darwin amd64 "$cmd" "$BUILD/tmp/$cmd-amd64"
  go run "$MAKEFAT" "$BUILD/bin/$cmd" "$BUILD/tmp/$cmd-arm64" "$BUILD/tmp/$cmd-amd64"
done
rm -rf "$BUILD/tmp"

jq --arg v "$VERSION" '.version = $v' "$ROOT/mcpb/manifest.json" > "$BUILD/manifest.json"
cp "$SRC/LICENSE" "$BUILD/LICENSE"

npx -y "$MCPB" validate "$BUILD/manifest.json"
npx -y "$MCPB" pack "$BUILD" "$DIST/ars-sicilia.mcpb"
echo "versione $VERSION"
