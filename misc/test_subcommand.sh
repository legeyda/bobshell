



shelduck import ../assert.sh
shelduck import ./subcommand.sh



test_subcommand() {
	unset x
	assert_die bobshell_subcommand f 3
	assert_unset x
	
	unset x
	bobshell_subcommand f 1
	assert_equals 1 "$x"

	unset x
	bobshell_subcommand f 2
	assert_equals 2 "$x"
}

f_1() {
	x=1
}

f_2() {
	x=2
}