
shelduck import ./assert.sh
shelduck import ./locator.sh




test_copy() {

  for type in file stdin stdout var val; do
    assert_error bobshell_copy $type:a stdin:
    assert_error bobshell_copy $type:a val:
    assert_error bobshell_copy stdout: $type:a
  done

  printf hello > a.txt
  bobshell_copy file:a.txt file:b.txt
  assert_equals hello "$(cat b.txt)"

  printf hello > a.txt
  assert_equals hello "$(bobshell_copy file:a.txt stdout:)"

  printf hello > a.txt
  bobshell_copy file:a.txt var:VAR
  assert_equals hello "$VAR"

  printf hi | bobshell_copy stdin: file:b.txt
  assert_equals hi "$(cat b.txt)"

  assert_equals hi "$(printf hi | bobshell_copy stdin: stdout:)"

  assert_equals hi "$(printf hi | ( bobshell_copy stdin: var:VAR_FROM_FILE; printf "$VAR_FROM_FILE"; ) )"

  VAR_TO_FILE=msg
  bobshell_copy var:VAR_TO_FILE file:c.txt
  assert_equals msg "$(cat c.txt)"
  assert_equals msg "$(VAR_TO_STDOUT=msg; bobshell_copy var:VAR_TO_STDOUT stdout: )"

  assert_empty "${VAR_FROM_VAR:-}"
  VAR_TO_VAR=pss
  bobshell_copy var:VAR_TO_VAR var:VAR_FROM_VAR
  assert_equals "$VAR_TO_VAR" "$VAR_FROM_VAR"

  bobshell_copy val:xxx file:d.txt
  assert_equals xxx "$(cat d.txt)"

  assert_equals xxx "$(bobshell_copy val:xxx stdout:)"
  
  bobshell_copy val:xxx var:FROM_VAL
  assert_equals xxx "$FROM_VAL"
}