

shelduck import base.sh

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

assert_unset() {
  if bobshell_isset "$1"; then
    assertion_error "variable $1 was not expected to be set"
  fi
}

assert_isset() {
	if bobshell_isset "$1"; then
		return
	fi
    assertion_error "variable $1 expected to be set"
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
	"$@" || assertion_error ok expected
}

assert_error() {
	"$@" && assertion_error failure expected || true
}

assert_file_exists() {
	if [ ! -f "$1" ]; then
		assertion_error "file expected to exist: $1"
	fi
}