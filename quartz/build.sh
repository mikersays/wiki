#!/usr/bin/env bash
# Build every vault in this repo into a static site under public/<vault>/.
# A vault is any top-level directory containing a wiki/ subfolder.
#
# Usage:
#   quartz/build.sh                    # build all vaults
#   quartz/build.sh ufo                # build a single vault
#   QUARTZ_BASE_HOST=foo.example.com \
#     quartz/build.sh                  # override the deploy hostname
#
# Required commands: git, node, npm.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
QUARTZ_DIR="$REPO_ROOT/.quartz-build"
PUBLIC_DIR="$REPO_ROOT/public"
QUARTZ_REF="${QUARTZ_REF:-v4.5.2}"
QUARTZ_REPO="${QUARTZ_REPO:-https://github.com/jackyzha0/quartz.git}"

# Hostname + path prefix the site is served from.
# Default matches GitHub Pages for mikersays/wiki: mikersays.github.io/wiki/<vault>
BASE_HOST="${QUARTZ_BASE_HOST:-mikersays.github.io}"
BASE_PATH="${QUARTZ_BASE_PATH:-/wiki}"

# 1. Clone Quartz at the pinned ref if we don't already have it.
if [ ! -d "$QUARTZ_DIR/.git" ]; then
  echo ">> cloning Quartz $QUARTZ_REF into $QUARTZ_DIR"
  git clone --depth 1 --branch "$QUARTZ_REF" "$QUARTZ_REPO" "$QUARTZ_DIR"
fi

# 2. Install Quartz dependencies (idempotent thanks to npm ci).
pushd "$QUARTZ_DIR" >/dev/null
if [ ! -d node_modules ]; then
  echo ">> installing Quartz dependencies"
  npm ci
fi
popd >/dev/null

# 3. Overlay our config on top of the upstream Quartz checkout.
cp "$REPO_ROOT/quartz/quartz.config.ts" "$QUARTZ_DIR/quartz.config.ts"
cp "$REPO_ROOT/quartz/quartz.layout.ts" "$QUARTZ_DIR/quartz.layout.ts"

# 4. Discover vaults: top-level directories with a wiki/ subfolder.
discover_vaults() {
  local d
  for d in "$REPO_ROOT"/*/; do
    [ -d "$d/wiki" ] || continue
    basename "$d"
  done
}

if [ "${1-}" != "" ]; then
  VAULTS=("$1")
else
  mapfile -t VAULTS < <(discover_vaults)
fi

if [ "${#VAULTS[@]}" -eq 0 ]; then
  echo "No vaults found (no top-level <name>/wiki/ directory)." >&2
  exit 1
fi

# 5. Build each vault into public/<vault>/.
rm -rf "$PUBLIC_DIR"
mkdir -p "$PUBLIC_DIR"

for vault in "${VAULTS[@]}"; do
  content="$REPO_ROOT/$vault/wiki"
  out="$PUBLIC_DIR/$vault"
  if [ ! -d "$content" ]; then
    echo "skipping $vault: no $content directory" >&2
    continue
  fi
  echo ">> building vault: $vault"
  pushd "$QUARTZ_DIR" >/dev/null
  QUARTZ_VAULT="$vault" \
  QUARTZ_TITLE="$vault wiki" \
  QUARTZ_BASE_URL="${BASE_HOST}${BASE_PATH}/${vault}" \
    npx quartz build --directory "$content" --output "$out"
  popd >/dev/null
done

# 6. Generate a top-level landing page that links to each vault.
echo ">> writing landing page at $PUBLIC_DIR/index.html"
{
  cat <<HEAD
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>wiki</title>
  <style>
    body { font-family: ui-sans-serif, system-ui, sans-serif; max-width: 40rem; margin: 4rem auto; padding: 0 1rem; color: #2b2b2b; }
    h1 { font-weight: 600; margin-bottom: 0.25rem; }
    p.lede { color: #666; margin-top: 0; }
    ul { list-style: none; padding: 0; }
    li { margin: 0.5rem 0; }
    a { color: #284b63; text-decoration: none; font-weight: 500; }
    a:hover { text-decoration: underline; }
    @media (prefers-color-scheme: dark) {
      body { background: #161618; color: #ebebec; }
      a { color: #7b97aa; }
      p.lede { color: #999; }
    }
  </style>
</head>
<body>
  <h1>wiki</h1>
  <p class="lede">A multi-vault personal knowledge base.</p>
  <ul>
HEAD
  for vault in "${VAULTS[@]}"; do
    [ -d "$PUBLIC_DIR/$vault" ] || continue
    printf '    <li><a href="./%s/">%s</a></li>\n' "$vault" "$vault"
  done
  cat <<TAIL
  </ul>
</body>
</html>
TAIL
} > "$PUBLIC_DIR/index.html"

echo ">> done. output in $PUBLIC_DIR"
