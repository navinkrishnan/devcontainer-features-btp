#!/usr/bin/env bash
set -e

source ./library_scripts.sh
ensure_nanolayer nanolayer_location "v0.5.6"

cf_version="${CF:-latest}"
pack_version="${PACK:-latest}"
cds_dk_version="${CDS_DK:-latest}"
mbt_version="${MBT:-latest}"
kubectl_version="${KUBECTL:-latest}"
kubelogin_version="${KUBELOGIN:-latest}"
helm_version="${HELM:-latest}"

echo "Got version for pack: $pack_version, cf: $cf_version, cds-dk: $cds_dk_version, mbt: $mbt_version, kubectl: $kubectl_version, kubelogin: $kubelogin_version, helm: $helm_version"

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
install_feature "$mbt_version" "mbt" "1.0.0"

# REVISIT: Following features are downloaded from external devcontainer-features
# to be moved to this repository in the future.
#####

install_additional_feature() {
  local version=$1
  local feature=$2
  local feature_version=$3
  local kubectl_version=$4
  local kubelogin_version=$5
  local helm_version=$6

  if [ "$version" != "none" ]; then
    echo "Installing $feature version: $version"
    $nanolayer_location install devcontainer-feature \
      "ghcr.io/rjfmachado/devcontainer-features/$feature:$feature_version" \
      --option azwi="none" --option cilium="none"  --option flux="none" \
      --option kubelogin="$kubelogin_version" --option kubectl="$kubectl_version" \
      --option helm="$helm_version"
  else
    echo "Skipping $feature"
  fi
}

install_additional_feature "1" "cloud-native" "1" \
  "$kubectl_version" "$kubelogin_version" "$helm_version"

echo "btp-cap-dev-stack installation complete."
