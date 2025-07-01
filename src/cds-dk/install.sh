#!/usr/bin/env bash
set -e

VERSION=${VERSION:-"latest"}

echo "📦 Installing SAP CAP CDS (cds-dk) version: $VERSION"

if [ "$VERSION" = "none" ]; then
  echo "⚠️  Skipping cds-dk installation (version=none)"
  exit 0
fi

# Ensure Node.js and npm are available
if ! command -v npm >/dev/null 2>&1; then
  echo "❌ npm is not available. Please install Node.js before installing cds-dk."
  exit 1
fi

# Install specific version or latest
if [ "$VERSION" = "latest" ]; then
  npm install -g @sap/cds-dk
else
  npm install -g @sap/cds-dk@$VERSION
fi

echo "✅ @sap/cds-dk installed successfully"
