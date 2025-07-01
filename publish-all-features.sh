for dir in src/*/; do
  feature=$(basename "$dir")
  version=$(jq -r '.version' "$dir/devcontainer-feature.json")
  major="${version%%.*}"
  minor="$(cut -d. -f1-2 <<< "$version")"

  echo "📦 Publishing $feature (v$version)..."

  devcontainer features publish "$dir" \
    --namespace navinkrishnan/devcontainer-features-btp \
    --version-alias "$major" \
    --version-alias "$minor"

  echo "✅ Published $feature:$version → :$minor, :$major"
done
