


shelduck import ../assert.sh
shelduck import ./unset.sh
shelduck import ./set.sh
shelduck import ./apply.sh


test_unset() {
	bobshell_result_unset
	assert_die bobshell_result_apply true	
}

test_empty() {
	bobshell_result_set
	x=$(bobshell_result_apply printf '%s')
	assert_equals '' "$x"
	
}

test_one() {
	bobshell_result_set one
	x=$(bobshell_result_apply printf '%s')
	assert_equals one "$x"
}

test_many() {
	bobshell_result_set 1 2 3 4 5 6 7 8 9 10 11 12 13
	x=$(bobshell_result_apply printf '%s %s %s %s %s %s %s %s %s %s %s %s %s')

	assert_equals '1 2 3 4 5 6 7 8 9 10 11 12 13' "$x"
}
