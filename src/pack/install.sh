#!/usr/bin/env bash
set -e

echo "📦 Installing Buildpacks Pack CLI version: $VERSION"

if [ "$VERSION" = "none" ]; then
  echo "⚠️  Skipping Pack CLI installation (version=none)"
  exit 0
fi

# If latest, fetch the version from GitHub API
if [ "$VERSION" = "latest" ]; then
  VERSION=$(curl -s https://api.github.com/repos/buildpacks/pack/releases/latest \
    | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')
  echo "📌 Resolved latest version to $VERSION"
fi

# Download and install
curl -sSL "https://github.com/buildpacks/pack/releases/download/v${VERSION}/pack-v${VERSION}-linux.tgz" \
  | tar -xz -C /usr/local/bin/ pack

chmod +x /usr/local/bin/pack
echo "✅ Pack CLI v$VERSION installed successfully"
