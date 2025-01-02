#!/usr/bin/env bats

load helpers/all_helpers.bash

@test "validate_input(): is called" {
  run_script <<-"EOT"
    source "main.bash"
    
    function validate_input() {
      echo "validate_input called"
    }
	EOT

  assert_success
  assert_output "validate_input called"
}

@test "validate_input(): not defined" {
  run_script <<-"EOT"
    source "main.bash"
	EOT

  assert_success
}
@test "validate_input(): nonzero return value exits the program" {
  run_script <<-EOT
    source "main.bash"

    function validate_input() {
      return 1
    }
	EOT

  assert_status 1
}
