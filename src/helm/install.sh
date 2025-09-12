#!/usr/bin/env bash
set -e

HELM_VERSION="${VERSION:-latest}"

echo "Downloading Helm..."

# Setup temporary directories
mkdir -p /tmp/helm
cd /tmp/helm

ARCH=$(uname -m)
case "$ARCH" in
    x86_64) ARCH="amd64" ;;
    aarch64 | arm64) ARCH="arm64" ;;
    *) echo "Unsupported architecture: $ARCH"; exit 1 ;;
esac

OS=$(uname | tr '[:upper:]' '[:lower:]')

if [ "${HELM_VERSION}" = "latest" ]; then
    HELM_VERSION=$(curl -fsSL https://api.github.com/repos/helm/helm/releases/latest | grep tag_name | cut -d '"' -f 4)
fi

echo "HELM_VERSION=${HELM_VERSION}"

helm_filename="helm-v${HELM_VERSION}-${OS}-${ARCH}.tar.gz"
tmp_helm_filename="/tmp/helm/${helm_filename}"

# --- Checksum handling ---
# Prefer raw .sha256 if available (old releases), otherwise parse .sha256.asc (new releases)
if curl -fsSL "https://get.helm.sh/${helm_filename}.sha256" -o "${tmp_helm_filename}.sha256"; then
    HELM_SHA256="$(cat "${tmp_helm_filename}.sha256")"
else
    curl -fsSL "https://github.com/helm/helm/releases/download/${HELM_VERSION}/${helm_filename}.sha256.asc" \
        -o "${tmp_helm_filename}.sha256.asc"

    # Extract SHA256 directly without verifying GPG signature
    HELM_SHA256="$(grep -Eo '^[0-9a-f]{64}' "${tmp_helm_filename}.sha256.asc")"
    echo "${HELM_SHA256}" > "${tmp_helm_filename}.sha256"
fi

# Download Helm tarball
curl -fsSL "https://get.helm.sh/${helm_filename}" -o "${tmp_helm_filename}"

# Verify checksum
echo "${HELM_SHA256}  ${tmp_helm_filename}" | sha256sum -c -

# Extract and install
tar -zxvf "${tmp_helm_filename}" --strip-components=1 "${OS}-${ARCH}/helm"
mv helm /usr/local/bin/helm
chmod +x /usr/local/bin/helm

# Cleanup
cd /
rm -rf /tmp/helm

echo "Helm ${HELM_VERSION} installed successfully!"
