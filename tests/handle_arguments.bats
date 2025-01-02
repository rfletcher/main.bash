#!/usr/bin/env bats

load helpers/all_helpers.bash

@test "handle_arguments(): is called" {
  run_script \
  <<-"EOT"
    source "main.bash"
    
    function handle_arguments() {
      echo "handle_arguments called"
    }
	EOT

  assert_success
  assert_output "handle_arguments called"
}

@test "handle_arguments(): present, no arguments passed" {
  run_script \
  <<-"EOT"
    source "main.bash"
    
    function handle_arguments() {
      echo "$#"
    }
	EOT

  assert_success
  assert_output 0
}

@test "handle_arguments(): present, multiple arguments passed" {
  run_script "an argument" "another argument" \
  <<-"EOT"
    source "main.bash"
    
    function handle_arguments() {
      echo "$#"
      echo "$1"
      echo "$2"
    }
	EOT

  assert_success
  assert_output 2 "an argument" "another argument"
}

@test "handle_arguments(): explicit option/argument separator is ignored" {
  run_script "--" "an argument" \
  <<-"EOT"
    source "main.bash"
    
    function handle_arguments() {
      echo "$#"
      echo "$1"
    }
	EOT

  assert_success
  assert_output "1" "an argument"
}

@test "handle_arguments(): not defined" {
  run_script "an argument" \
  <<-"EOT"
    source "main.bash"
	EOT

  assert_success
}

@test "handle_arguments(): nonzero return value exits the program" {
  run_script <<-EOT
    source "main.bash"

    function handle_arguments() {
      return 1
    }
	EOT

  assert_status 1
}
