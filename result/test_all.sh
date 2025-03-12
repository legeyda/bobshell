


shelduck import ../assert.sh
shelduck import ./check.sh
shelduck import ./false.sh
shelduck import ./get.sh
shelduck import ./set.sh
shelduck import ./true.sh
shelduck import ./use.sh
shelduck import ./printf.sh



test_check_true() {
	bobshell_result_true
	if bobshell_result_check; then
		true
	else
		assertion_error 'if'
	fi
}

test_check_false() {
	bobshell_result_false
	if bobshell_result_check; then
		assertion_error 'if'
	else
		true
	fi
}

test_set_get() {
	bobshell_result_set 1 2 3
	assert_equals '1 2 3' "$(bobshell_result_get)"
}

test_use() {
	bobshell_result_set hello
	bobshell_result_use bobshell_putvar x
	assert_equals hello "$x"
}

test_printf() {
	bobshell_result_printf %s hello
	bobshell_result_use bobshell_putvar x
	assert_equals hello "$x"
}