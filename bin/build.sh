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
	--exclude='version.html' \
	--exclude '.build_counter' \
    "$TMP_DIR/" "$BUILD_DIR/"


git -C "$BUILD_DIR" add -A

if git -C "$BUILD_DIR" diff --cached --quiet; then
  echo "No real content changes"
  exit 0
fi

echo "Changes detected"
git -C "$BUILD_DIR" diff --cached --stat


## Versioning 
GIT_SHA=$(git rev-parse --short HEAD)
BUILD_TIME=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# increment build number
BUILD_COUNTER_FILE="$BUILD_DIR/.build_counter"
[ -f "$BUILD_COUNTER_FILE" ] || echo 0 > "$BUILD_COUNTER_FILE"
BUILD_NUMBER=$(($(cat "$BUILD_COUNTER_FILE") + 1))
echo $BUILD_NUMBER > "$BUILD_COUNTER_FILE"

# version.json
cat > "$BUILD_DIR/version.json" <<EOF
{
  "build_number": $BUILD_NUMBER,
  "build_time": "$BUILD_TIME",
  "commit": "$GIT_SHA"
}
EOF

# version.html
cat > "$BUILD_DIR/version.html" <<EOF
<!doctype html>
<html>
<head><meta charset="utf-8"><title>Build</title></head>
<body>
<h3>Build Info</h3>
<ul>
<li>Build: $BUILD_NUMBER</li>
<li>Commit: $GIT_SHA</li>
<li>Time: $BUILD_TIME</li>
</ul>
</body>
</html>
EOF

# commit only real changes
git -C "$BUILD_DIR" add -A

if git -C "$BUILD_DIR" diff --cached --quiet; then
  echo "Nothing to commit"
  exit 0
fi

echo "Committing..."
git -C "$BUILD_DIR" commit -m "deploy: $BUILD_TIME" || echo "Nothing to commit"

echo "Build complete"
echo "Build number: $BUILD_NUMBER"
echo "Commit: $GIT_SHA"
echo "Build time: $BUILD_TIME"