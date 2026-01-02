#!/usr/bin/env bash
set -euo pipefail

VERSION="${VERSION:-latest}"

echo "==> Installing Cloud Foundry CLI (VERSION=${VERSION})"

if [[ "$VERSION" == "none" ]]; then
  echo "==> Skipping CF CLI installation"
  exit 0
fi

# Detect architecture
ARCH="$(uname -m)"
case "$ARCH" in
  x86_64) CF_ARCH="x86-64" ;;
  aarch64|arm64) CF_ARCH="arm64" ;;
  *)
    echo "Unsupported architecture: $ARCH"
    exit 1
    ;;
esac

# Resolve version
if [[ "$VERSION" == "latest" ]]; then
  VERSION=$(curl -fsSL https://api.github.com/repos/cloudfoundry/cli/releases/latest \
    | grep '"tag_name":' \
    | sed -E 's/.*"v([^"]+)".*/\1/')
fi

echo "==> Resolved CF CLI version: $VERSION"
DEB_NAME="cf8-cli-installer_${VERSION}_${CF_ARCH}.deb"
URL="https://github.com/cloudfoundry/cli/releases/download/v${VERSION}/${DEB_NAME}"

TMP_DIR="$(mktemp -d)"
echo "==> Downloading ${URL}"
curl -fsSL "$URL" -o "${TMP_DIR}/${DEB_NAME}"

echo "==> Installing .deb package..."
apt-get update
apt-get install -y --no-install-recommends \
    curl ca-certificates

dpkg -i "${TMP_DIR}/${DEB_NAME}" || apt-get -f install -y

rm -rf "${TMP_DIR}"

echo "==> Verifying installation"
cf8 version || cf version

echo "==> CF CLI installation completed"
