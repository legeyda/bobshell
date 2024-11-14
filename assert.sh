

success() {
	printf '%s: all tests passed\n' "$0"
}

assertion_error() {
	# https://github.com/biox/pa/blob/main/pa
	printf '%s: assertion error: %s.\n' "$(basename "$0")" "${*:-error}" >&2
	exit 1
}



assert_equals() {
	if [ "$1" != "$2" ]; then
		assertion_error "actual value <$2> expected to be equal to <$1>${3:+ $3}"
	fi
}

assert_not_equals() {
	if [ "$1" = "$2" ]; then
		assertion_error "actual value <$2> expected not to be equal to <$1>${3:+: $3}"
	fi
}

assert_var_not_set() {
  if [ "$(eval "printf %s \"\${$1+set}\"")" = set ]; then
    assertion_error "variable $1 was not expected to be set"
  fi
}

assert_empty() {
	if [ -n "$1" ]; then
		assertion_error "actual value expected to be empty${2:+: $2}"
	fi
}

assert_not_empty() {
	if [ -z "$1" ]; then
		assertion_error "actual value expected not to be empty${2:+: $2}"
	fi
}

assert_ok() {
	assert_result 0 "$@" 
}

assert_error() {
	assert_not_equals 0 "$(print_result_code "$@")"
}

assert_result() {
	assert_result_expected="$1"
	shift
	assert_result_actual=$(print_result_code "$@")
	assert_equals "$assert_result_expected" "$assert_result_actual" "${2:-}"
}