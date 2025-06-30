#!/usr/bin/env bash

set -euo pipefail

# === CONFIGURATION ===
NAMESPACE="navinkrishnan/devcontainer-features-btp"
PROJECT_FOLDER="."
SRC_DIR="src"

# === START ===
echo "🚀 Starting publish for Dev Container features under namespace: $NAMESPACE"
echo

# Loop through each feature in src/
for feature_dir in "$SRC_DIR"/*/; do
  feature_name=$(basename "$feature_dir")
  feature_json="${feature_dir}/devcontainer-feature.json"

  if [[ ! -f "$feature_json" ]]; then
    echo "⚠️  Skipping $feature_name (no devcontainer-feature.json found)"
    continue
  fi

  version=$(jq -r '.version' "$feature_json")
  if [[ "$version" == "null" || -z "$version" ]]; then
    echo "❌ No version found for $feature_name, skipping"
    continue
  fi

  major="${version%%.*}"                      # e.g. 1 from 1.2.3
  minor="$(cut -d. -f1-2 <<< "$version")"     # e.g. 1.2 from 1.2.3

  echo "📦 Publishing feature: $feature_name"
  echo "   ➤ Version: $version"
  echo "   ➤ Aliases: $major, $minor"

  # Optional: Generate README.md
  echo "📝 Generating README.md..."
  (
    cd "$feature_dir"
    devcontainer features generate-docs \
      --namespace "$NAMESPACE"
  )

  # Build feature (optional step)
  devcontainer features build \
    --namespace "$NAMESPACE" \
    --project-folder "$PROJECT_FOLDER" \
    --features "$feature_name"

  # Publish with full + alias tags
  devcontainer features publish \
    --namespace "$NAMESPACE" \
    --project-folder "$PROJECT_FOLDER" \
    --features "$feature_name" \
    --version-alias "$major" \
    --version-alias "$minor"

  echo "✅ Published: ghcr.io/$NAMESPACE/$feature_name:$version ($major, $minor)"
  echo
done

echo "🎉 All features published successfully!"
