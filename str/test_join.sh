
shelduck import ../assert.sh
shelduck import ./join.sh


test_join_none() {
	bobshell_str_join xyz
	assert_equals '' "$bobshell_result_1"
}

test_join_one() {
	bobshell_str_join ', ' 1
	assert_equals 1 "$bobshell_result_1"
}

test_join() {
	bobshell_str_join ', ' 1 2 3
	assert_equals '1, 2, 3' "$bobshell_result_1"
}
