#!/bin/bash

set -e

# Optional: Import test library
source dev-container-features-test-lib

# Definition specific tests
check "cds-dk" cds v -i

# Report result
reportResults