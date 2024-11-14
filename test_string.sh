#!/bin/sh
set -eu


shelduck string.sh
shelduck assert.sh



test_ends_with() {
	bobshell_ends_with bobshell_echo echo || bobshell_die expected true
	bobshell_ends_with bobshell_echo echo result
	assert_equals bobshell_ "$result"
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
	bobshell_contains hello el || bobshell_die true expected
	bobshell_contains hello x  && bobshell_die false expected || true
	bobshell_contains "hello 'there'" "'" || bobshell_die true expected

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

	bobshell_contains abc = key value && bobshell_die 'error expected'
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
	bobshell_is_regex_match hello 'x.*'    && bobshell_die 'expected false'
	bobshell_is_regex_match hello 'h.*'    || bobshell_die 'expected true'
	bobshell_is_regex_match hello 'los$'   && bobshell_die 'expected false'
	bobshell_is_regex_match hello 'lo$'    && bobshell_die 'expected false (^ is implicitly prepended to regex)'
	bobshell_is_regex_match hello '.*lo$'  || bobshell_die 'expected true'
	bobshell_is_regex_match hello '^.*lo$' || bobshell_die 'expected true'
	bobshell_basic_regex_match 123 '[0-9]\+' || bobshell_die expected true
}

test_extended_regex_match() {
	bobshell_extended_regex_match 123 '[0-9]+' || bobshell_die expected true
}

test_quote() {
	assert_equals "1 2 3" "$(bobshell_quote 1 2 3)"
	assert_equals "1 '2 3'" "$(bobshell_quote 1 '2 3')"
	assert_equals "'hello '\"'\"'there'\"'\"''" "$(bobshell_quote "hello 'there'")"
}
