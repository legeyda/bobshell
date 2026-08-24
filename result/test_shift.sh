


shelduck import ../assert.sh
shelduck import ./set.sh
shelduck import ./unset.sh
shelduck import ./shift.sh


test_none() {
	bobshell_result_unset
	assert_die bobshell_result_shift
}

test_empty() {
	bobshell_result_set
	bobshell_result_shift

	assert_equals 0 "$bobshell_result_size"
	assert_unset bobshell_result_1
}

test_more() {
	bobshell_result_set singleton
	bobshell_result_shift 2

	assert_equals 0 "$bobshell_result_size"
	assert_unset bobshell_result_1
}


test_normal() {
	bobshell_result_set one two three
	bobshell_result_shift 2
	
	assert_equals 1 "$bobshell_result_size"
	assert_equals three "$bobshell_result_1"
	assert_unset bobshell_result_2
	assert_unset bobshell_result_3
}
