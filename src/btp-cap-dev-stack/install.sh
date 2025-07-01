#!/usr/bin/env bash
set -e

source ./library_scripts.sh
ensure_nanolayer nanolayer_location "v0.5.6"

cf_version="${CF:-latest}"
pack_version="${PACK:-latest}"
cds_dk_version="${CDS_DK:-latest}"

echo "Got version for pack: $pack_version, cf: $cf_version, cds-dk: $cds_dk_version"

install_feature() {
  local version=$1
  local feature=$2
  local feature_version=$3

  if [ "$version" != "none" ]; then
    echo "Installing $feature version: $version"
    $nanolayer_location install devcontainer-feature \
      "ghcr.io/navinkrishnan/devcontainer-features-btp/$feature:$feature_version" \
      --option version="$version"
  else
    echo "Skipping $feature"
  fi
}

install_feature "$cf_version" "cf" "1.0.0"
install_feature "$pack_version" "pack" "1.0.0"
install_feature "$cds_dk_version" "cds-dk" "1.0.0"

echo "btp-cap-dev-stack installation complete."
