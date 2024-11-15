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
	assert_error bobshell_remove_prefix bobshell_echo 123
}


test_ends_with() {
	assert_ok bobshell_ends_with bobshell_echo echo
	assert_error bobshell_starts_with bobshell_echo 123
}

test_remove_suffix() {
	suffix=0
	assert_ok bobshell_remove_suffix bobshell_echo echo prefix
	assert_equals "bobshell_" "$prefix"
	assert_error bobshell_remove_suffix bobshell_echo 123
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


test_contains() {
	assert_ok bobshell_contains hello el
	assert_error bobshell_contains hello x
	assert_ok bobshell_contains "hello 'there'" "'"

	bobshell_contains 1=2 = key value
	assert_equals 1 "$key"
	assert_equals 2 "$value"
	unset key value

	bobshell_contains 1= = key value
	assert_equals 1 "$key"
	assert_equals '' "$value"
	unset key value

	bobshell_contains '=2' = key value
	assert_equals '' "$key"
	assert_equals 2 "$value"
	unset key value

	bobshell_contains '**=***' = key value
	assert_equals '**' "$key"
	assert_equals '***' "$value"
	unset key value

	assert_error bobshell_contains abc = key value
	assert_var_not_set key
	assert_var_not_set value


	bobshell_contains '1
2' '
' key value
	assert_equals 1 "$key"
	assert_equals 2 "$value"
	unset key value
	

}

test_basic_regex_match() {
	assert_error bobshell_is_regex_match hello 'x.*'
	assert_ok bobshell_is_regex_match hello 'h.*'
	assert_error bobshell_is_regex_match hello 'los$'
	assert_error bobshell_is_regex_match hello 'lo$'
	assert_ok bobshell_is_regex_match hello '.*lo$'
	assert_ok bobshell_is_regex_match hello '^.*lo$'
	assert_ok bobshell_basic_regex_match 123 '[0-9]\+'
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
