


shelduck import ../assert.sh
shelduck import ./set.sh
shelduck import ./unset.sh
shelduck import ./assert.sh


test_undefined() {
	assert_die bobshell_result_assert
}

test_empty() {
	bobshell_result_set
	assert_die bobshell_result_assert
}

test_true() {
	bobshell_result_set true
	bobshell_result_assert
}

test_true_read() {
	bobshell_result_set true 1 2 3
	unset a b c
	bobshell_result_assert a b c
	assert_equals 1 "$a"
	assert_equals 2 "$b"
	assert_equals 3 "$c"
}

test_false1() {
	bobshell_result_set false
	assert_die bobshell_result_assert
}

test_false2() {
	bobshell_result_set false 1 2 3
	unset a b c
	assert_die bobshell_result_assert a b c
	assert_unset a
	assert_unset b
	assert_unset c
}

test_msg() {
    bobshell_app_name=testapp

	bobshell_result_unset
	assert_die bobshell_result_assert -- test_msg: assertion failed
	assert_die bobshell_result_assert --
	assert_die bobshell_result_assert

	x=$(set +x; assert_die bobshell_result_assert -- errmsg 2>&1)
	assert_equals 'testapp: errmsg' "$x"

	x=$(set +x; assert_die bobshell_result_assert 2>&1)
	assert_equals 'testapp: assertion failed: no result' "$x"






	bobshell_result_set false
	x=$(set +x; assert_die bobshell_result_assert 2>&1)
	assert_equals 'testapp: assertion failed: unknown error' "$x"

	bobshell_result_set false
	x=$(set +x; assert_die bobshell_result_assert x y z -- custom assertion failed 2>&1)
	assert_equals 'testapp: custom assertion failed: unknown error' "$x"

	bobshell_result_set false error message 1
	x=$(set +x; assert_die bobshell_result_assert x y z 2>&1)
	assert_equals 'testapp: assertion failed: error message 1' "$x"

	bobshell_result_set false error message 2
	x=$(set +x; assert_die bobshell_result_assert -- custom assertion failed 2>&1)
	assert_equals 'testapp: custom assertion failed: error message 2' "$x"




	bobshell_result_set true 1 2
	x=$(set +x; assert_die bobshell_result_assert x y z -- custom assertion failed 2>&1)
	assert_equals 'testapp: custom assertion failed: unsufficient result size' "$x"

	bobshell_result_set true 1 2
	x=$(set +x; assert_die bobshell_result_assert x y z 2>&1)
	assert_equals 'testapp: assertion failed: unsufficient result size' "$x"

	
}
