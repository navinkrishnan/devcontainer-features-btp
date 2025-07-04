#!/usr/bin/env bash
set -e

VERSION=${VERSION:-"latest"}

echo "📦 Installing SAP Cloud MTA Build Tool (mbt) version: $VERSION"

if [ "$VERSION" = "none" ]; then
  echo "⚠️  Skipping mbt installation (version=none)"
  exit 0
fi

# Ensure Node.js and npm are available
if ! command -v npm >/dev/null 2>&1; then
  echo "❌ npm is not available. Please install Node.js before installing mbt."
  exit 1
fi

# Install specific version or latest
if [ "$VERSION" = "latest" ]; then
  npm install -g mbt
else
  npm install -g mbt@$VERSION
fi

echo "✅ Cloud MTA Build Tool (mbt) installed successfully"
