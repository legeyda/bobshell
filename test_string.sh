#!/bin/sh
set -eu


shelduck import string.sh
shelduck import assert.sh


test_starts_with() {
	assert_ok bobshell_starts_with bobshell_echo bob
	assert_error bobshell_starts_with bobshell_echo 123
}

test_remove_prefix() {
	suffix=0
	assert_ok bobshell_remove_prefix bobshell_echo bob suffix
	assert_equals "shell_echo" "$suffix"
	assert_error bobshell_remove_prefix bobshell_echo 123 x
}


test_ends_with() {
	assert_ok bobshell_ends_with bobshell_echo echo
	assert_error bobshell_starts_with bobshell_echo 123
}

test_remove_suffix() {
	suffix=0
	assert_ok bobshell_remove_suffix bobshell_echo echo prefix
	assert_equals "bobshell_" "$prefix"
	assert_error bobshell_remove_suffix bobshell_echo 123 x
}



_test_for_each_part() {
	result=
	bobshell_for_each_part '1 2 3' ' ' part 'eval result="$result$part"'
	assert_equals 123 "$result"

	result=
	bobshell_for_each_part '1 2 3
	4 5 6
	7 8 9' '
	' part 'printf %s $part'

	false
}


test_replace() {
	assert_equals hELLo "$(bobshell_replace hello ell ELL)"
}


test_split_first() {

	bobshell_split_first 1=2 = key value
	assert_equals 1 "$key"
	assert_equals 2 "$value"
	unset key value

	bobshell_split_first 1= = key value
	assert_equals 1 "$key"
	assert_equals '' "$value"
	unset key value

	bobshell_split_first '=2' = key value
	assert_equals '' "$key"
	assert_equals 2 "$value"
	unset key value

	bobshell_split_first '**=***' = key value
	assert_equals '**' "$key"
	assert_equals '***' "$value"
	unset key value

	assert_error bobshell_split_first abc = key value
	assert_unset key
	assert_unset value

	bobshell_split_first '1
2' '
' key value
	assert_equals 1 "$key"
	assert_equals 2 "$value"
	unset key value
	
}


test_split_last() {
	bobshell_split_last '1=2=3' = key value
	assert_equals 1=2 "$key"
	assert_equals 3 "$value"
	unset key value
}

test_contains() {
	assert_ok bobshell_contains hello ell
	assert_ok bobshell_contains "hello 'there'" "'"



}

test_basic_regex_match() {
	assert_error bobshell_basic_regex_match hello 'x.*'
	assert_ok bobshell_basic_regex_match hello 'h.*'
	assert_error bobshell_basic_regex_match hello 'los$'
	assert_error bobshell_basic_regex_match hello 'lo$'
	assert_ok bobshell_basic_regex_match hello '.*lo$'
	assert_ok bobshell_basic_regex_match hello '^.*lo$'
	assert_ok bobshell_basic_regex_match 123 '[0-9]\+'


	assert_ok bobshell_basic_regex_match '  shelduck   import   blabla\n' '^\s*shelduck\s\+import\s\+.*$'
	#assert_ok bobshell_basic_regex_match "$bobshell_newline" '^\n.*$'
}

test_extended_regex_match() {
	assert_ok bobshell_extended_regex_match 123 '[0-9]+'
	assert_error bobshell_extended_regex_match hello '[0-9]+'
}

test_quote() {
	assert_equals "1 2 3" "$(bobshell_quote 1 2 3)"
	assert_equals "1 '2 3'" "$(bobshell_quote 1 '2 3')"
	assert_equals "'hello '\"'\"'there'\"'\"''" "$(bobshell_quote "hello 'there'")"
}


test_strip_left() {
	result=$(bobshell_strip_left '   blabla  ')
	assert_equals 'blabla  ' "$result"
}

test_strip_right() {
	result=$(bobshell_strip_right '  blabla  ')
	assert_equals '  blabla' "$result"
}

test_strip() {
	result=$(bobshell_strip '  blabla  ')
	assert_equals blabla "$result"
}

# 
test_mustache() {
	template='hello, {{      name}}, greetings!'
	name=bob

	output=$(bobshell_mustache "$template")
	assert_equals 'hello, bob, greetings!' "$output"
}


# 
test_mustache_scope() {
	template='hello, {{  name }}, message is: {{   msg}}!'
	x_name=bob
	x_msg='secret message'

	output=$(bobshell_mustache "$template" x_)
	assert_equals 'hello, bob, message is: secret message!' "$output"
}
