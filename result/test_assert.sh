


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
	assert_equals 'testapp: assertion failed' "$x"

}
