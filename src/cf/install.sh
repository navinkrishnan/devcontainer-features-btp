#!/usr/bin/env bash
set -euo pipefail

echo "📦 Installing Cloud Foundry CLI (APT-based)"
echo "➡️  Requested version: ${VERSION:-latest}"

# -------------------------------
# Skip installation
# -------------------------------
if [ "${VERSION:-latest}" = "none" ]; then
  echo "⚠️  Skipping cf CLI installation (version=none)"
  exit 0
fi

# -------------------------------
# Install dependencies
# -------------------------------
apt-get update
apt-get install -y --no-install-recommends \
  ca-certificates \
  curl \
  gnupg

# -------------------------------
# Add CF CLI GPG key (modern way)
# -------------------------------
install -m 0755 -d /etc/apt/keyrings

curl -fsSL https://packages.cloudfoundry.org/debian/cli.cloudfoundry.org.key \
  | gpg --dearmor \
  | tee /etc/apt/keyrings/cloudfoundry-cli.gpg > /dev/null

chmod 0644 /etc/apt/keyrings/cloudfoundry-cli.gpg

# -------------------------------
# Add CF CLI APT repository
# -------------------------------
echo "deb [signed-by=/etc/apt/keyrings/cloudfoundry-cli.gpg] https://packages.cloudfoundry.org/debian stable main" \
  > /etc/apt/sources.list.d/cloudfoundry-cli.list

# -------------------------------
# Install CF CLI
# -------------------------------
apt-get update

if [ "${VERSION:-latest}" = "latest" ]; then
  apt-get install -y --no-install-recommends cf8-cli
else
  apt-get install -y --no-install-recommends "cf8-cli=${VERSION}*"
fi

# -------------------------------
# Cleanup
# -------------------------------
apt-get clean
rm -rf /var/lib/apt/lists/*

# -------------------------------
# Verify
# -------------------------------
cf version

echo "✅ Cloud Foundry CLI installation complete"
