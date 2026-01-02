#!/usr/bin/env bash
set -e

echo "📦 Installing Buildpacks Pack CLI version: $VERSION"

if [ "$VERSION" = "none" ]; then
  echo "⚠️ Skipping Pack CLI installation (version=none)"
  exit 0
fi

# Resolve latest version from GitHub API if requested
if [ "$VERSION" = "latest" ]; then
  VERSION=$(curl -fsSL https://api.github.com/repos/buildpacks/pack/releases/latest \
    | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')
  echo "📌 Resolved latest version to $VERSION"
fi

# Detect architecture
ARCH="$(uname -m)"
case "$ARCH" in
  x86_64)
    PLATFORM="linux"
    ;;
  aarch64|arm64)
    PLATFORM="linux-arm64"
    ;;
  *)
    echo "❌ Unsupported architecture: $ARCH"
    exit 1
    ;;
esac

echo "🧭 Detected architecture: $PLATFORM"

# Get download URL from GitHub API (only pick the .tgz, not .sha256)
ASSET_URL=$(curl -fsSL "https://api.github.com/repos/buildpacks/pack/releases/tags/v$VERSION" \
  | grep "browser_download_url" \
  | grep "$PLATFORM.tgz\"" \
  | grep -v "sha256" \
  | cut -d '"' -f 4)

if [ -z "$ASSET_URL" ]; then
  echo "❌ ERROR: No Pack CLI tarball found for version $VERSION and platform $PLATFORM"
  exit 1
fi

echo "🌐 Downloading Pack CLI from $ASSET_URL"

# Download and extract the 'pack' binary
curl -fsSL "$ASSET_URL" | tar -xz -C /usr/local/bin/ pack

chmod +x /usr/local/bin/pack
echo "✅ Pack CLI v$VERSION installed successfully"
