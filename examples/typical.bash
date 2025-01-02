#!/usr/bin/env bash

# include main.bash, whether we're invoked as ./examples/typical.bash, or ./typical.bash
source "$(dirname "${BASH_SOURCE[0]}")/../main.bash"

# set variable defaults
INPUT=
VERBOSE=0

# declare supported options, and handle one when passed
function handle_option() {
  case "$1" in
    "") export OPT_SPEC=":v";; # declare which options are supported
    v) VERBOSE=1;;             # handle -v
  esac
}

# save non-option arguments for later
function handle_arguments() {
  INPUT="$1"
}

# validate input
function validate_input() {
  if [[ "$INPUT" == "" ]]; then
    echo "Error: One argument is required, but nothing was passed. Try again with an argument." >&2
    echo "Usage: $0 <argument>" >&2
    return 1
  fi
}

# perform any cleanup before exiting
function quit() {
  echo -ne "\nShutting down"
}

# reload configuration, etc.
function reload() {
  echo -e "\nLoading configuration"
}

# having handled and validated input, run the primary script
function main() {
  if [[ "$VERBOSE" == "1" ]]; then
    echo "Hello, World!"
  fi
  echo "You passed: $INPUT"

  reload

  echo "^C to exit"

  while true; do
    echo -n .; sleep 1
  done
}
