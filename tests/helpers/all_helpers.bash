bats_require_minimum_version 1.10.0

load helpers/assertion_helpers.bash

function run_script() {
  local input="$(cat -)"
  local e E T oldIFS
  [[ ! "$-" =~ e ]] || e=1
  [[ ! "$-" =~ E ]] || E=1
  [[ ! "$-" =~ T ]] || T=1
  set +e
  set +E
  set +T
  output="$(echo "$input" | bash /dev/stdin "$@" 2>&1)"
  status="$?"
  oldIFS=$IFS
  IFS=$'\n' lines=($output)
  [ -z "$e" ] || set -e
  [ -z "$E" ] || set -E
  [ -z "$T" ] || set -T
  IFS=$oldIFS
}
