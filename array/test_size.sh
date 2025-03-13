
shelduck import ../assert.sh
shelduck import ./set.sh
shelduck import ./unset.sh

test_undefined() {
	assert_die bobshell_array_size myarr
}

test_size_0() {
	bobshell_array_set myarr
	assert_equals 0 "$(bobshell_array_size myarr)"
}

test_size() {
	# assert_error bobshell_array_size # exit
	assert_ok echo "$(bobshell_array_size)" # !!!

	bobshell_array_set myarr one two three
	assert_equals 3 "$(bobshell_array_size myarr)"
}