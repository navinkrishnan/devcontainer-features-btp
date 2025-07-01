#!/usr/bin/env bash
set -euo pipefail

# Download a file in a lightweight, cross-platform way
clean_download() {
    local url=$1
    local output_path=$2

    if command -v curl >/dev/null 2>&1; then
        curl -sSL "$url" -o "$output_path"
    elif command -v wget >/dev/null 2>&1; then
        wget -q "$url" -O "$output_path"
    else
        echo "❌ Neither curl nor wget is available for downloading $url"
        exit 1
    fi
}

# Ensure nanolayer is available and of correct version
ensure_nanolayer() {
    local result_var_name=$1
    local required_version=$2
    local nanolayer_path=""

    # Normalize version (prepend 'v' if missing)
    [[ $required_version != v* ]] && required_version="v$required_version"

    # Check if preinstalled and correct version
    if command -v nanolayer >/dev/null 2>&1; then
        local current_version
        current_version=$(nanolayer --version)
        [[ $current_version != v* ]] && current_version="v$current_version"
        if [[ "$current_version" == "$required_version" ]]; then
            nanolayer_path="nanolayer"
        else
            echo "⚠️ Found nanolayer, but version mismatch: $current_version != $required_version"
        fi
    fi

    # Download if missing or incorrect version
    if [[ -z "$nanolayer_path" ]]; then
        echo "⬇️  Downloading nanolayer $required_version..."
        local tmp_dir
        tmp_dir=$(mktemp -d)

        # trap 'rm -rf "$tmp_dir"' EXIT
        # Guard to only remove tmp_dir if it is defined and not empty
        trap '[ -n "${tmp_dir:-}" ] && rm -rf "$tmp_dir"' EXIT

        local arch
        arch="$(uname -m)"
        local libc="gnu"
        [[ -x /sbin/apk ]] && libc="musl"

        local tar_file="nanolayer-${arch}-unknown-linux-${libc}.tgz"
        local url="https://github.com/devcontainers-extra/nanolayer/releases/download/${required_version}/${tar_file}"
        local archive="$tmp_dir/$tar_file"

        clean_download "$url" "$archive"
        tar -xzf "$archive" -C "$tmp_dir"
        chmod +x "$tmp_dir/nanolayer"
        nanolayer_path="$tmp_dir/nanolayer"
    fi

    # Export result to caller
    declare -g "$result_var_name"="$nanolayer_path"
}
