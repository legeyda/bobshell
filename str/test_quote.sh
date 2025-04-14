
shelduck import ../assert.sh
shelduck import ./quote.sh

test_quote() {
	bobshell_str_quote 1 2 3
	assert_equals "1 2 3" "$bobshell_result_1"

	bobshell_quote 1 '2 3'
	assert_equals "1 '2 3'" "$bobshell_result_1"

	bobshell_quote "hello 'there'"
	assert_equals "'hello '\"'\"'there'\"'\"''" "hello 'there'"

	bobshell_quote 1/2.3-4=5_6
	assert_equals '1/2.3-4=5_6' "$bobshell_result_1"

	bobshell_quote "$bobshell_newline"
	assert_equals "'$bobshell_newline'" "$bobshell_result_1"
	
}