
shelduck import ../assert.sh
shelduck import ./repeat.sh


test_repeat() {
	bobshell_str_repeat 3 xyz
	assert_equals xyzxyzxyz "$bobshell_result_1"


}

test_empty() {
	bobshell_str_repeat 3
	assert_equals '' "$bobshell_result_1"

}
