


shelduck import ../assert.sh
shelduck import ./set.sh
shelduck import ./unset.sh


test_unset() {
	bobshell_result_set 1 2 3
	bobshell_result_unset
	assert_unset bobshell_result_size
	assert_unset bobshell_result_1
	assert_unset bobshell_result_2
	assert_unset bobshell_result_3
}
