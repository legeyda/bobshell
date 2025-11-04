


shelduck import ../assert.sh
shelduck import ./unset.sh
shelduck import ./set.sh
shelduck import ./remove.sh


test_unset() {
	bobshell_result_unset
	assert_die bobshell_result_remove 1 item
}

test_empty() {
	bobshell_result_set
	assert_die bobshell_result_remove
	assert_die bobshell_result_remove 0
	assert_die bobshell_result_remove 1
	assert_die bobshell_result_remove 3
}

test_single() {
	bobshell_result_set init
	assert_die bobshell_result_remove
	assert_die bobshell_result_remove 0
	assert_die bobshell_result_remove 3
	bobshell_result_remove 1
	assert_equals 0 "$bobshell_result_size"
	assert_unset bobshell_result_1
}

test_double_1() {
	bobshell_result_set one two
	assert_die bobshell_result_remove
	assert_die bobshell_result_remove 0
	assert_die bobshell_result_remove 3
	bobshell_result_remove 2
	assert_equals 1 "$bobshell_result_size"
	assert_equals one "$bobshell_result_1"
	bobshell_result_remove 1
	assert_equals 0 "$bobshell_result_size"
	assert_unset bobshell_result_1
}

test_double_2() {
	bobshell_result_set one two
	assert_die bobshell_result_remove
	assert_die bobshell_result_remove 0
	assert_die bobshell_result_remove 3
	bobshell_result_remove 1 2
	assert_equals 0 "$bobshell_result_size"
	assert_unset bobshell_result_1
}