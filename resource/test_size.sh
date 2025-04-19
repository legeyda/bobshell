
shelduck import ../assert.sh
shelduck import ./size.sh
shelduck import ../result/assert.sh

test_val() {
	bobshell_resource_size val:
	bobshell_result_check x
	assert_equals 0 "$x"


	bobshell_resource_size val:123
	bobshell_result_check x
	assert_equals 3 "$x"


	
}


test_var() {
	y=
	bobshell_resource_size var:y
	bobshell_result_check x
	assert_equals 0 "$x"

	# y=123
	# bobshell_resource_size var:y
	# bobshell_result_check x
	# assert_equals 3 "$x"




}