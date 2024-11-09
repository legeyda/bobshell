
assert_empty         "$(Y=$(echo hello; die); echo "$Y")" # as expected: nothing printed
assert_not_empty "$(echo "$(echo hello; die)")" # strange: value printed after exit
assert_empty "$(: "${Z:=$(die)}"; echo "$Z")"

assert_error invoke_self eval 'alias run_test_alias_for_echo=echo; run_test_alias_for_echo'
assert_equals hello "$(invoke_self eval 'run_test_alias_for_echo() { echo "$@"; }; run_test_alias_for_echo hello')"
assert_equals hello "$(invoke_self eval 'superalias run_test_alias_for_echo=echo; run_test_alias_for_echo hello')"
