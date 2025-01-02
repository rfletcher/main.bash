##
# main.bash: A tiny framework for Bash scripts
#
# https://github.com/rfletcher/main.bash
#

## Set defaults

_MAINBASH_ARGS=( "$@" )
_MAINBASH_INITIALIZED=

## Define functions

function __function_exists() {
  declare -F "$1" &>/dev/null
}

function __main() {
  if [[ "$_MAINBASH_INITIALIZED" != "" ]]; then
    return 0
  else
    _MAINBASH_INITIALIZED=1
    trap - EXIT
  fi

  local ARGS=()
  local OPT_SPEC=":"

  function ___parse_arguments() {
    local HANDLES_OPTS=
    local OPTIND=0

    # does the command script accept options?
    if __function_exists handle_option; then
      HANDLES_OPTS=1
      handle_option - || exit $?
    fi

    # parse either way, so we can complain when options are provided but none are expected
    while getopts "$OPT_SPEC" OPT; do
      if [[ "$OPT" == "?" ]]; then
        echo "Error: Unknown option (-${OPTARG})" >&2
        exit 1
      elif [[ "$HANDLES_OPTS" == "1" ]]; then
        handle_option "$OPT" "$OPTARG" || exit $?
      fi
    done
    shift $((OPTIND-1))
    unset OPT_SPEC

    [[ "$1" == "--" ]] && shift

    # save remaining arguments
    ARGS=( "$@" )

    unset _MAINBASH_ARGS
  }

  ___parse_arguments "${_MAINBASH_ARGS[@]}"

  if __function_exists handle_arguments; then
    handle_arguments "${ARGS[@]}" || exit $?
  fi
  if __function_exists validate_input; then
    validate_input || exit $?
  fi
  if __function_exists main; then
    main || exit $?
  fi
}

function __reload() {
  __function_exists reload && reload
}

function __quit() {
  __function_exists quit && quit "$1"

  trap - "$1"
  kill -"$1" -$$
  exit
}

## Define hooks

# handle ^C, etc.
trap "__quit INT" INT
trap "__quit TERM" TERM

# reload on SIGHUP
trap __reload HUP

## Run main()
trap __main EXIT
