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

TMP_DIR=$(mktemp -d)

echo "Building Astro..."
npx astro build --outDir "$TMP_DIR"

echo "Syncing to deploy repo..."
rsync -av --delete --exclude='.git' "$TMP_DIR/" "$BUILD_DIR/"

echo "Cleaning up..."
rm -rf "$TMP_DIR"

echo "Committing..."
git -C "$BUILD_DIR" add -A
git -C "$BUILD_DIR" commit -m "deploy: $(date -u +%Y-%m-%dT%H:%M:%SZ)" || echo "Nothing to commit"