#!/usr/bin/env bash

# include main.bash, whether we're invoked as ./examples/minimal.bash, or ./minimal.bash
source "$(dirname "${BASH_SOURCE[0]}")/../main.bash"

# run the primary script
function main() {
  echo "Hello, World!"
}
