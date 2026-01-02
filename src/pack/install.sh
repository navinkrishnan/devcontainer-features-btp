#!/usr/bin/env bash
set -e

echo "📦 Installing Buildpacks Pack CLI version: $VERSION"

if [ "$VERSION" = "none" ]; then
  echo "⚠️  Skipping Pack CLI installation (version=none)"
  exit 0
fi

# If latest, fetch the version from GitHub API
if [ "$VERSION" = "latest" ]; then
  VERSION=$(curl -fsSL https://api.github.com/repos/buildpacks/pack/releases/latest \
    | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')
  echo "📌 Resolved latest version to $VERSION"
fi

# Detect architecture
ARCH="$(uname -m)"
case "$ARCH" in
  x86_64)
    ARCH="amd64"
    ;;
  aarch64 | arm64)
    ARCH="arm64"
    ;;
  *)
    echo "❌ Unsupported architecture: $ARCH"
    exit 1
    ;;
esac

echo "🧭 Detected architecture: linux-$ARCH"

# Download and install correct binary
curl -fsSL "https://github.com/buildpacks/pack/releases/download/v${VERSION}/pack-v${VERSION}-linux-${ARCH}.tgz" \
  | tar -xz -C /usr/local/bin/ pack

chmod +x /usr/local/bin/pack
echo "✅ Pack CLI v$VERSION installed successfully"
