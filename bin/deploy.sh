#!/bin/bash
set -e
# 1. Load Environment Variables
if [ -f .env ]; then
  set -a
  source .env
  set +a
fi

# Validate paths
if [ -z "$BUILD_DIR" ]; then
  echo "Error: BUILD_DIR must be set in .env"
  exit 1
fi

echo "Running production build..."

echo "Temporarily stepping into deployment directory..."
cd "$BUILD_DIR"

echo "Checking remote tracking branch..."
UPSTREAM=$(git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null || echo "")

if [ -z "$UPSTREAM" ]; then
  echo "No upstream set. Configuring remote with token..."
  CLEAN_REMOTE=$(echo "$GIT_DEPLOY_REMOTE" | sed -E 's|https://[^@]+@|https://|')
  REMOTE_PATH="${CLEAN_REMOTE#https://github.com/}"
  AUTH_URL="https://x-oauth-basic:${GIT_TOKEN}@github.com/${REMOTE_PATH}"
  
  git remote set-url origin "$AUTH_URL"
  
  set +e
  git push -u origin "$GIT_DEPLOY_BRANCH"
  PUSH_STATUS=$?
  set -e
  
  if [ $PUSH_STATUS -ne 0 ]; then
    read -p "⚠️ Push rejected! FORCE push? (y/N): " CONFIRM
    [[ "$CONFIRM" =~ ^[Yy]$ ]] && git push -f -u origin "$GIT_DEPLOY_BRANCH" || exit 1
  fi
else
  echo "Upstream already set: $UPSTREAM"
  set +e
  git push
  PUSH_STATUS=$?
  set -e
  
  # Handle rejection
  if [ $PUSH_STATUS -ne 0 ]; then
    read -p "⚠️ Push rejected! FORCE push? (y/N): " CONFIRM
    [[ "$CONFIRM" =~ ^[Yy]$ ]] && git push -f || exit 1
  fi
fi

echo "🚀 Deployment finished!