#!/usr/bin/env bash
set -e

echo "📦 Installing Cloud Foundry CLI version: $VERSION"

if [ "$VERSION" = "none" ]; then
  echo "⚠️  Skipping cf CLI installation (version=none)"
  exit 0
fi

# Ensure required tools exist
apt-get update
apt-get install -y --no-install-recommends curl ca-certificates gnupg

# Create keyring folder if missing
mkdir -p /usr/share/keyrings

echo "🔑 Downloading CF CLI GPG key..."
curl -fsSL https://packages.cloudfoundry.org/debian/cli.cloudfoundry.org.key \
  -o /usr/share/keyrings/cloudfoundry-cli-archive-keyring.gpg

echo "📦 Adding Cloud Foundry APT repo (signed-by)..."
cat <<EOF >/etc/apt/sources.list.d/cloudfoundry-cli.list
deb [signed-by=/usr/share/keyrings/cloudfoundry-cli-archive-keyring.gpg] https://packages.cloudfoundry.org/debian stable main
EOF

apt-get update

# Install the cf CLI (v8) if version is 'latest'
if [ "$VERSION" = "latest" ]; then
  echo "⬇️ Installing latest cf8-cli from apt..."
  apt-get install -y --no-install-recommends cf8-cli
else
  echo "⬇️ Installing Cloud Foundry CLI version ${VERSION} (manual binary)..."
  curl -sL "https://packages.cloudfoundry.org/stable?release=linux64&version=${VERSION}" -o cf-cli.tgz
  tar -xzf cf-cli.tgz
  mv cf /usr/local/bin/cf
  chmod +x /usr/local/bin/cf
  rm -f cf-cli.tgz
fi

# Clean up
rm -rf /var/lib/apt/lists/*
echo "✅ cf CLI installation complete"
