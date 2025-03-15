


shelduck import ../assert.sh
shelduck import ./set.sh


test_set() {
	bobshell_result_set
	assert_equals 0 "$bobshell_result_size"
	assert_unset bobshell_result_1
}
