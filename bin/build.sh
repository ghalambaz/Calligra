#!/bin/bash
set -e

if [ -f .env ]; then
  set -a
  source .env
  set +a
fi

if [ -z "$BUILD_DIR" ]; then
  echo "Error: BUILD_DIR must be set in .env"
  exit 1
fi

TMP_DIR=.dist

echo "Building Astro..."
npx astro build --outDir "$TMP_DIR"

echo "Syncing to deploy repo..."
# Sync and capture output

# Perform the actual sync
rsync \
    -rc \
    --delete \
    --exclude='.git' \
    --exclude='version.json' \
    "$TMP_DIR/" "$BUILD_DIR/"


git -C "$BUILD_DIR" add -A

if git -C "$BUILD_DIR" diff --cached --quiet; then
  echo "No real content changes"
  exit 0
fi

echo "Changes detected"
git -C "$BUILD_DIR" diff --cached --stat

BUILD_ID=$(TZ=UTC date +%Y%m%d%H%M%S)
BUILD_COMMIT=$(git rev-parse --short HEAD)

echo "Generating version file..."
echo "{\"build\": \"$BUILD_ID\", \"timestamp\": \"$(date -u)\", \"commit\": \"$BUILD_COMMIT\"}" > "$BUILD_DIR/version.json"

echo "Committing..."
git -C "$BUILD_DIR" add -A
git -C "$BUILD_DIR" commit -m "deploy: $(date -u +%Y-%m-%dT%H:%M:%SZ)" || echo "Nothing to commit"