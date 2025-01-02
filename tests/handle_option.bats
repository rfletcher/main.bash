#!/usr/bin/env bats

load helpers/all_helpers.bash

@test "handle_option(): is called" {
  run_script \
  <<-"EOT"
    source "main.bash"
    
    function handle_option() {
      echo "handle_option called"
    }
	EOT

  assert_success
  assert_output "handle_option called"
}

@test "handle_option(): no arguments" {
  run_script \
  <<-"EOT"
    source "main.bash"
    
    function handle_option() {
      echo "handle_option called"
    }
	EOT

  assert_success
  assert_output "handle_option called"
}

@test "handle_option(): option passed" {
  run_script -x -y \
  <<-"EOT"
    source "main.bash"
    
    function handle_option() {
      case "$1" in
        -) export OPT_SPEC=":xyz";;
        x) echo "got -x";;
        y) echo "got -y";;
        z) echo "got -z";;
      esac
    }
	EOT

  assert_success
  assert_output "got -x" "got -y"
}

@test "handle_option(): option with value" {
  run_script -x 'a value' \
  <<-"EOT"
    source "main.bash"
    
    function handle_option() {
      case "$1" in
        -) export OPT_SPEC=":x:";;
        x) echo "got -x with '$2'";;
      esac
    }
	EOT

  assert_success
  assert_output "got -x with 'a value'"
}

@test "handle_option(): explicit non-option separator" {
  run_script -x 'a value' -- "a value" \
  <<-"EOT"
    source "main.bash"
    
    function handle_arguments() {
      echo "$#"
      echo "$*"
    }
    
    function handle_option() {
      case "$1" in
        -) export OPT_SPEC=":x:";;
        x) echo "got -x with '$2'";;
      esac
    }
	EOT

  assert_success
  assert_output "got -x with 'a value'" 1 "a value"
}

@test "handle_option(): option passed without handler" {
  run_script "-h" foo \
  <<-"EOT"
    source "main.bash"
	EOT

  assert_failure
  assert_error /-h/
}

@test "handle_option(): unsupport option passed" {
  run_script "-h" foo \
  <<-"EOT"
    source "main.bash"
    
    function handle_option() {
      export OPT_SPEC="";;
    }
	EOT

  assert_failure
  assert_error /-h/
}

@test "handle_option(): nonzero return value exits the program" {
  run_script <<-EOT
    source "main.bash"

    function handle_option() {
      return 1
    }
	EOT

  assert_status 1
}
