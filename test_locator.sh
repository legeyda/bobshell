





test_copy() {


	

  parse_locator file:1
  assert_equals file "$parse_locator_type"
  assert_equals 1 "$parse_locator_ref"

  for type in file stdin stdout var val; do
    assert_error copy_resource $type:a stdin:
    assert_error copy_resource $type:a val: 
    assert_error copy_resource stdout: $type:a 
  done

  printf hello > a.txt
  copy_resource file:a.txt file:b.txt
  assert_equals hello "$(cat b.txt)"

  printf hello > a.txt
  assert_equals hello "$(copy_resource file:a.txt stdout:)"

  printf hello > a.txt
  copy_resource file:a.txt var:VAR
  assert_equals hello "$VAR"

  printf hi | copy_resource stdin: file:b.txt
  assert_equals hi "$(cat b.txt)"

  assert_equals hi "$(printf hi | copy_resource stdin: stdout:)"

  assert_equals hi "$(printf hi | ( copy_resource stdin: var:VAR_FROM_FILE; printf "$VAR_FROM_FILE"; ) )"

  VAR_TO_FILE=msg
  copy_resource var:VAR_TO_FILE file:c.txt
  assert_equals msg "$(cat c.txt)"
  assert_equals msg "$(VAR_TO_STDOUT=msg; copy_resource var:VAR_TO_STDOUT stdout: )"

  assert_empty "${VAR_FROM_VAR:-}"
  VAR_TO_VAR=pss
  copy_resource var:VAR_TO_VAR var:VAR_FROM_VAR
  assert_equals "$VAR_TO_VAR" "$VAR_FROM_VAR"

  copy_resource val:xxx file:d.txt
  assert_equals xxx "$(cat d.txt)"

  assert_equals xxx "$(copy_resource val:xxx stdout:)"
  
  copy_resource val:xxx var:FROM_VAL
  assert_equals xxx "$FROM_VAL"
}