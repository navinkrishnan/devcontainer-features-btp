#!/usr/bin/env bash
set -euo pipefail

echo "==> Installing Cloud Foundry CLI (VERSION=${VERSION:-latest})"
export DEBIAN_FRONTEND=noninteractive

# ------------------------------------------------------------
# Handle "none"
# ------------------------------------------------------------
if [[ "${VERSION:-latest}" == "none" ]]; then
  echo "==> Skipping CF CLI installation"
  exit 0
fi

# ------------------------------------------------------------
# Detect architecture
# ------------------------------------------------------------
ARCH="$(dpkg --print-architecture)"
case "$ARCH" in
  amd64) CF_ARCH="linux64" ;;
  arm64) CF_ARCH="linuxarm64" ;;
  *)
    echo "Unsupported architecture: $ARCH"
    exit 1
    ;;
esac

# ------------------------------------------------------------
# Install prerequisites
# ------------------------------------------------------------
apt-get update
apt-get install -y --no-install-recommends \
  curl \
  ca-certificates \
  gnupg \
  tar

# ------------------------------------------------------------
# Install latest via APT (best path)
# ------------------------------------------------------------
if [[ "${VERSION:-latest}" == "latest" ]]; then
  echo "==> Installing latest CF CLI via APT"

  CF_KEYRING="/usr/share/keyrings/cloudfoundry-cli.gpg"
  curl -fsSL https://packages.cloudfoundry.org/debian/cli.cloudfoundry.org.key \
    | gpg --dearmor -o "$CF_KEYRING"

  echo "deb [signed-by=$CF_KEYRING] https://packages.cloudfoundry.org/debian stable main" \
    > /etc/apt/sources.list.d/cloudfoundry-cli.list

  apt-get update
  apt-get install -y --no-install-recommends cf8-cli

# ------------------------------------------------------------
# Install pinned version via tarball
# ------------------------------------------------------------
else
  echo "==> Installing CF CLI version ${VERSION} via tarball (${CF_ARCH})"

  TMP_DIR="$(mktemp -d)"
  curl -fsSL \
    "https://packages.cloudfoundry.org/stable?release=${CF_ARCH}&version=${VERSION}" \
    -o "${TMP_DIR}/cf.tgz"

  tar -xzf "${TMP_DIR}/cf.tgz" -C "${TMP_DIR}"
  mv "${TMP_DIR}/cf" /usr/local/bin/cf
  chmod +x /usr/local/bin/cf
  rm -rf "${TMP_DIR}"
fi

# ------------------------------------------------------------
# Verify & cleanup
# ------------------------------------------------------------
cf version

apt-get clean
rm -rf /var/lib/apt/lists/*

echo "==> CF CLI installation completed"
