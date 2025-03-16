


shelduck import ../assert.sh
shelduck import ./set.sh
shelduck import ./write.sh

test_undefined() {
	assert_die bobshell_array_write myarr
	assert_die bobshell_array_write myarr 1
	assert_die bobshell_array_write myarr 1 x
}

test_empty() {
	bobshell_array_set myarr
	assert_die bobshell_array_write myarr
	assert_die bobshell_array_write myarr 1
	assert_die bobshell_array_write myarr 1 x
}

test_write() {
	bobshell_array_set myarr one two three

	assert_die bobshell_array_write myarr 0
	assert_die bobshell_array_write myarr 0 zero

	bobshell_array_write myarr 1 eins
	bobshell_array_write myarr 2 zwei
	bobshell_array_write myarr 3 drei

	assert_equals eins "$myarr_1"
	assert_equals zwei "$myarr_2"
	assert_equals drei "$myarr_3"

	assert_die bobshell_array_write myarr 4
	assert_die bobshell_array_write myarr 4 four
}