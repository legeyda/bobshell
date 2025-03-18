
shelduck import ../assert.sh
shelduck import ./set.sh
shelduck import ./size.sh
shelduck import ../result/assert.sh

test_undefined() {
	assert_die bobshell_array_size myarr
}

test_size_0() {
	bobshell_array_set myarr
	bobshell_array_size myarr
	unset x
	bobshell_result_assert x
	assert_equals 0 "$x"
}

test_size() {
	bobshell_array_set myarr one two three
	bobshell_array_size myarr
	unset x
	bobshell_result_assert x
	assert_equals 3 "$x"
}