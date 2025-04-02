


shelduck import ../assert.sh
shelduck import ./set.sh
shelduck import ./unset.sh

test_unset() {
	bobshell_array_set myarr one two three
	bobshell_array_unset myarr
	assert_unset myarr_size
	assert_unset myarr_1
	assert_unset myarr_2
	assert_unset myarr_3
}

test_0() {
	bobshell_array_set myarr
	bobshell_array_unset myarr
	assert_unset myarr_size
}
