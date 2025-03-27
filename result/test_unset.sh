


shelduck import ../assert.sh
shelduck import ./unset.sh


test_unset() {
	bobshell_result_size=3
	bobshell_result_1=one
	bobshell_result_2=two
	bobshell_result_3=three
	bobshell_result_unset
	assert_unset bobshell_result_size
	assert_unset bobshell_result_1
	assert_unset bobshell_result_2
	assert_unset bobshell_result_3
}
