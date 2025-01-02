#!/usr/bin/env bats

load helpers/all_helpers.bash

@test "main(): is called" {
  run_script <<-EOT
    source "main.bash"

    function main() {
      echo "main called"
    }
	EOT

  assert_success
  assert_output "main called"
}

@test "main(): not defined" {
  run_script <<-EOT
    source "main.bash"

    echo "Hello, World!"
	EOT

  assert_success
}

@test "main(): return value is used as exit status" {
  run_script <<-EOT
    source "main.bash"

    function main() {
      true
    }
	EOT

  assert_status 0

  run_script <<-EOT
    source "main.bash"

    function main() {
      return 127
    }
	EOT

  assert_status 127
}
