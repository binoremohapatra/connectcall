#!/bin/bash

# Build script for ConnectCall with Agora App ID
# Usage: ./build.sh <agora_app_id> [debug|release]

AGORA_APP_ID=$1
BUILD_TYPE=${2:-debug}

if [ -z "$AGORA_APP_ID" ]; then
    echo "Error: Agora App ID is required"
    echo "Usage: ./build.sh <agora_app_id> [debug|release]"
    exit 1
fi

echo "Building ConnectCall..."
echo "Agoda App ID: $AGORA_APP_ID"
echo "Build Type: $BUILD_TYPE"

if [ "$BUILD_TYPE" = "release" ]; then
    flutter build apk --dart-define=AGORA_APP_ID=$AGORA_APP_ID --release
else
    flutter build apk --dart-define=AGORA_APP_ID=$AGORA_APP_ID --debug
fi
