

shelduck import ../assert.sh
shelduck import ./random.sh


test_random() {
	assert_not_equals "$(bobshell_random)" "$(bobshell_random)"
}

