


shelduck import ../assert.sh
shelduck import ./set.sh

test_set_empty() {
	bobshell_array_set myarr
	assert_unset myarr_0
	assert_equals 0 "$myarr_size"
	assert_unset myarr_4
}

test_set_not_empty() {
	bobshell_array_set myarr one two three
	assert_unset myarr_0
	assert_equals 3 "$myarr_size"
	assert_equals one   "$myarr_1"
	assert_equals two   "$myarr_2"
	assert_equals three "$myarr_3"
	assert_unset myarr_4
}