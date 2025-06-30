#!/bin/bash

set -e

# Optional: Import test library
source dev-container-features-test-lib

# Definition specific tests
check "cds-dk" cds v -i
check "node" node --version
check "npm" npm --version
check "java" java --version
check "cf" cf --version
check "pack" pack version
check "kube" kubectl
check "helm" helm version

# Report result
reportResults