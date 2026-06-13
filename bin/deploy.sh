#!/bin/bash
set -e

# 1. Load Environment Variables
if [ -f .env ]; then
  set -a
  source .env
  set +a
fi

# 2. Validate Base Directory Variable
if [ -z "$BUILD_DIR" ]; then
  echo "Error: BUILD_DIR must be set in .env"
  exit 1
fi

echo "Checking remote tracking branch..."
UPSTREAM=$(git -C "$BUILD_DIR" rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null || echo "")

# 3. Configure Remote and Tracking Branch if Missing
if [ -z "$UPSTREAM" ]; then
  echo "No upstream set. Configuring remote with token..."

  if [ -z "$GIT_TOKEN" ] || [ -z "$GIT_DEPLOY_BRANCH" ] || [ -z "$GIT_DEPLOY_REMOTE" ]; then
    echo "Error: GIT_TOKEN, GIT_DEPLOY_BRANCH, and GIT_DEPLOY_REMOTE must be set in .env"
    exit 1
  fi

  CLEAN_REMOTE=$(echo "$GIT_DEPLOY_REMOTE" | sed -E 's|https://[^@]+@|https://|')
  REMOTE_PATH="${CLEAN_REMOTE#https://github.com/}"
  AUTH_URL="https://x-oauth-basic:${GIT_TOKEN}@github.com/${REMOTE_PATH}"
  
  git -C "$BUILD_DIR" remote set-url origin "$AUTH_URL"

  echo "Setting upstream tracking branch to origin/$GIT_DEPLOY_BRANCH..."
  
  # Temporary disable exit-on-error to catch a push rejection
  set +e
  git -C "$BUILD_DIR" push -u origin "$GIT_DEPLOY_BRANCH"
  PUSH_STATUS=$?
  set -e

  # Handle Push Failure / Rejection
  if [ $PUSH_STATUS -ne 0 ]; then
    echo ""
    echo "⚠️ Push rejected! The remote branch might contain changes you don't have locally."
    read -p "Do you want to FORCE push and overwrite remote changes? (y/N): " CONFIRM
    if [[ "$CONFIRM" =~ ^[Yy]$ ]]; then
      echo "Force-pushing to origin/$GIT_DEPLOY_BRANCH..."
      git -C "$BUILD_DIR" push -f -u origin "$GIT_DEPLOY_BRANCH"
    else
      echo "Push aborted by user."
      exit 1
    fi
  fi
  
  echo "Deployment successful."
  exit 0
fi

# 4. Standard Push Flow (If Upstream Was Already Configured)
echo "Upstream already set: $UPSTREAM"

set +e
git -C "$BUILD_DIR" push
PUSH_STATUS=$?
set -e

# Handle Push Failure for standard tracking branch flow
if [ $PUSH_STATUS -ne 0 ]; then
  echo ""
  echo "⚠️ Push rejected! The remote branch has diverged."
  read -p "Do you want to FORCE push? (y/N): " CONFIRM
  if [[ "$CONFIRM" =~ ^[Yy]$ ]]; then
    echo "Force-pushing changes..."
    git -C "$BUILD_DIR" push -f
  else
    echo "Push aborted by user."
    exit 1
  fi
fi

echo "Push completed successfully."#!/bin/bash
set -e

# 1. Load Environment Variables
if [ -f .env ]; then
  set -a
  source .env
  set +a
fi

# 2. Validate Base Directory Variable
if [ -z "$BUILD_DIR" ]; then
  echo "Error: BUILD_DIR must be set in .env"
  exit 1
fi

echo "Checking remote tracking branch..."
UPSTREAM=$(git -C "$BUILD_DIR" rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null || echo "")

# 3. Configure Remote and Tracking Branch if Missing
if [ -z "$UPSTREAM" ]; then
  echo "No upstream set. Configuring remote with token..."

  if [ -z "$GIT_TOKEN" ] || [ -z "$GIT_DEPLOY_BRANCH" ] || [ -z "$GIT_DEPLOY_REMOTE" ]; then
    echo "Error: GIT_TOKEN, GIT_DEPLOY_BRANCH, and GIT_DEPLOY_REMOTE must be set in .env"
    exit 1
  fi

  CLEAN_REMOTE=$(echo "$GIT_DEPLOY_REMOTE" | sed -E 's|https://[^@]+@|https://|')
  REMOTE_PATH="${CLEAN_REMOTE#https://github.com/}"
  AUTH_URL="https://x-oauth-basic:${GIT_TOKEN}@github.com/${REMOTE_PATH}"
  
  git -C "$BUILD_DIR" remote set-url origin "$AUTH_URL"

  echo "Setting upstream tracking branch to origin/$GIT_DEPLOY_BRANCH..."
  
  # Temporary disable exit-on-error to catch a push rejection
  set +e
  git -C "$BUILD_DIR" push -u origin "$GIT_DEPLOY_BRANCH"
  PUSH_STATUS=$?
  set -e

  # Handle Push Failure / Rejection
  if [ $PUSH_STATUS -ne 0 ]; then
    echo ""
    echo "⚠️ Push rejected! The remote branch might contain changes you don't have locally."
    read -p "Do you want to FORCE push and overwrite remote changes? (y/N): " CONFIRM
    if [[ "$CONFIRM" =~ ^[Yy]$ ]]; then
      echo "Force-pushing to origin/$GIT_DEPLOY_BRANCH..."
      git -C "$BUILD_DIR" push -f -u origin "$GIT_DEPLOY_BRANCH"
    else
      echo "Push aborted by user."
      exit 1
    fi
  fi
  
  echo "Deployment successful."
  exit 0
fi

# 4. Standard Push Flow (If Upstream Was Already Configured)
echo "Upstream already set: $UPSTREAM"

set +e
git -C "$BUILD_DIR" push
PUSH_STATUS=$?
set -e

# Handle Push Failure for standard tracking branch flow
if [ $PUSH_STATUS -ne 0 ]; then
  echo ""
  echo "⚠️ Push rejected! The remote branch has diverged."
  read -p "Do you want to FORCE push? (y/N): " CONFIRM
  if [[ "$CONFIRM" =~ ^[Yy]$ ]]; then
    echo "Force-pushing changes..."
    git -C "$BUILD_DIR" push -f
  else
    echo "Push aborted by user."
    exit 1
  fi
fi

echo "Push completed successfully."