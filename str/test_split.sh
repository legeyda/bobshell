
shelduck import ../assert.sh
shelduck import split.sh

test_split() {
	assert_equals 1/2/3/4/ "$(bobshell_str_split 1.2.3.4 . printf '%s/')"
	assert_equals hello/   "$(bobshell_str_split hello   . printf '%s/')"
}