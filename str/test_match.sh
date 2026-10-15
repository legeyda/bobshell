
shelduck import ../assert.sh
shelduck import ./match.sh

assert_result_equals() {
	assert_equals "$#" "$bobshell_result_size"

	_assert_result_equals__i=1
	while [ $# -gt 0 ]; do
		eval 'x="$bobshell_result_'"$_assert_result_equals__i"'"'
		assert_equals "$1" "$x"
		_assert_result_equals__i=$(( _assert_result_equals__i + 1 ))
		shift
	done
	unset assert_result_equals
}

test_0() {
	bobshell_str_match hello '*ll*'
	assert_result_equals true


	bobshell_str_match hello '*ll*'
	assert_result_equals true
}


test_empty() {
	bobshell_str_match '' ''
	assert_result_equals true

	bobshell_str_match '' '*'
	assert_result_equals true

	bobshell_str_match '' 'x'
	assert_result_equals false

}

test_quote() {
	bobshell_str_match xyz/=. '*[!-A-Za-z0-9_/=.]*'
	assert_result_equals false

	bobshell_str_match ' ' '*[!-A-Za-z0-9_/=.]*'
	assert_result_equals true

	bobshell_str_match '&' '*[!-A-Za-z0-9_/=.]*'
	assert_result_equals true

	bobshell_str_match ':' '*[!-A-Za-z0-9_/=.]*'
	assert_result_equals true

}

test_var() {
	bobshell_str_match x '*[!0-9]*'
	assert_result_equals true

	bobshell_str_match 1 '[A-Za-z_][A-Za-z_0-9]*'
	assert_result_equals false


}


test_1() {
	bobshell_str_match 123 '[123][123]*'
	assert_result_equals true
#
# 	assert_ok bobshell_str_match 123
# 	assert_error bobshell_str_match blabla '[[:digit:]]\+'
#
# 	assert_error bobshell_str_match hello 'x.*'
# 	assert_ok bobshell_str_match hello 'h.*'
# 	assert_error bobshell_str_match hello '^los$'
# 	assert_error bobshell_str_match hello '^lo$'
# 	assert_ok bobshell_str_match hello '.*lo$'
# 	assert_ok bobshell_str_match hello '^.*lo$'
# 	assert_ok bobshell_str_match 123 '[0-9]\+'
#
# 	assert_ok  bobshell_str_match hello.AppImage '^.*\.AppImage$'
# 	assert_ok  bobshell_str_match d5727d84ac69a0235ebef74b26577f190c7ec8321d5612182c210886f7a8fc8a '^[0-9a-f]\{64\}*$'
#
#
#
# 	assert_ok bobshell_str_match '  shelduck   import   blabla\n' '^\s*shelduck\s\+import\s\+.*$'
# 	#assert_ok bobshell_str_match "$bobshell_newline" '^\n.*$'
}

test_backslash() {
	bobshell_str_match '\' '*\\*'
	assert_result_equals true

	bobshell_str_match '*' '*\\*'
	assert_result_equals false


}

test_url() {
	bobshell_str_match 'https://raw.githubusercontent.com/legeyda/shelduck/refs/heads/main/shelduck.sh' 'https://raw.githubusercontent.com/*'
	assert_result_equals true

	bobshell_str_match "https://example.com" 'https://raw.githubusercontent.com/*'
	assert_result_equals false
}
