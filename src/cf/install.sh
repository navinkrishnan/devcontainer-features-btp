#!/usr/bin/env bash
set -e

echo "📦 Installing Cloud Foundry CLI version: $VERSION"

if [ "$VERSION" = "none" ]; then
  echo "⚠️  Skipping cf CLI installation (version=none)"
  exit 0
fi

# Add Cloud Foundry CLI APT repo
wget -q -O - https://packages.cloudfoundry.org/debian/cli.cloudfoundry.org.key | apt-key add -
echo "deb https://packages.cloudfoundry.org/debian stable main" > /etc/apt/sources.list.d/cloudfoundry-cli.list
apt-get update

# Install the cf CLI (v8) if version is 'latest'
if [ "$VERSION" = "latest" ]; then
  apt-get install -y --no-install-recommends cf8-cli
else
  # Install a specific version manually
  curl -sL "https://packages.cloudfoundry.org/stable?release=linux64&version=${VERSION}" -o cf-cli.tgz
  tar -xzf cf-cli.tgz
  mv cf /usr/local/bin/cf
  chmod +x /usr/local/bin/cf
  rm -f cf-cli.tgz
fi

# Clean up
rm -rf /var/lib/apt/lists/*
echo "✅ cf CLI installation complete"
