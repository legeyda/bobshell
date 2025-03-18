


shelduck import ../assert.sh
shelduck import ./set.sh
shelduck import ./check.sh


test_undefined() {
	assert_die bobshell_result_check
}

test_empty() {
	bobshell_result_set
	assert_die bobshell_result_check
}

test_true() {
	bobshell_result_set true
	bobshell_result_check
}

test_true_read() {
	bobshell_result_set true 1 2 3
	bobshell_result_check a b c
	assert_equals 1 "$a"
	assert_equals 2 "$b"
	assert_equals 3 "$c"
}

test_false1() {
	bobshell_result_set false
	assert_error bobshell_result_check
}

test_false2() {
	bobshell_result_set false 1 2 3
	assert_error bobshell_result_check a b c
	assert_unset a
	assert_unset b
	assert_unset c
}