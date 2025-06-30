#!/usr/bin/env bash

ensure_nanolayer() {
    local __resultvar=$1
    local version=$2
    local bin_path="/usr/local/bin/nanolayer"

    if command -v nanolayer >/dev/null 2>&1; then
        eval "$__resultvar='nanolayer'"
    else
        curl -sSL "https://github.com/devcontainers/cli/releases/download/${version}/nanolayer-linux" -o "$bin_path"
        chmod +x "$bin_path"
        eval "$__resultvar='$bin_path'"
    fi
}
