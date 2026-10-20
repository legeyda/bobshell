

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

assert_result_equals() {
	assert_result_equals_util "$@"

	_assert_result_equals__i=1
	while [ "$_assert_result_equals__i" -le "$bobshell_result_size" ]; do
		eval '_assert_result_equals__item="$bobshell_result_'"$_assert_result_equals__i"'"'
		if ! [ "$1" = "$_assert_result_equals__item" ]; then
			assertion_error "$_assert_result_equals__msg: result value #$_assert_result_equals__i <$_assert_result_equals__item> expected to be equal to <$1>"
			unset _assert_result_equals__item _assert_result_equals__msg
		fi
		_assert_result_equals__i=$(( _assert_result_equals__i + 1 ))
		shift
	done
	unset _assert_result_equals__i _assert_result_equals__item _assert_result_equals__msg
}

assert_result_equals_util() {
	_assert_result_equals_util__size_expected=0
	while [ "$#" -gt 0 ]; do
		if [ "$1" = -- ]; then
			shift
			break
		fi
		shift
		_assert_result_equals_util__size_expected=$((_assert_result_equals_util__size_expected+1))
	done

	_assert_result_equals__msg="${*:-assert_result_equals failed}"
	if [ -z "${bobshell_result_size:-}" ]; then
		assertion_error "$_assert_result_equals__msg: result expected"
	fi

	if [ "$_assert_result_equals_util__size_expected" != "$bobshell_result_size" ]; then
		assertion_error "$_assert_result_equals__msg: result size expected to be $_assert_result_equals_util__size_expected actual $bobshell_result_size"
	fi

	unset _assert_result_equals_util__size_expected
}

assert_result_size() {
	if [ "$1" != "${bobshell_result_size:-}" ]; then
		_assert_result_size__expected="$1"
		shift
		assertion_error "${*:-result size assertion failed}: result size expected $_assert_result_size__expected actual $bobshell_result_size"
		unset _assert_result_size__expected
	fi
}

bobshell_get_rest_of_args() {
	while [ $# -gt 0 ]; do
		if [ "$1" = -- ]; then
			break
		fi
		shift
	done

}


assert_contains() {
	case "$1" in
		(*$2*) true ;;
		(*)    assertion_error "actual value <$1> expected to contain substring <$2>${3:+ $3}" ;;
	esac
}

assert_not_contains() {
	case "$1" in
		(*$2*) assertion_error "actual value <$1> expected NOT to contain substring <$2>${3:+ $3}" ;;
		(*)    true ;;
	esac
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

assert_die() {
	_assert_die=$(printf %s "$("$@"; printf %s "b62c4c96289d46d5b0f23692ffc8295e657030357ab74d799a5abb79c54a2ca558485d5449fd467e838526b4023e7026")")
	case "$_assert_die" in
		(*b62c4c96289d46d5b0f23692ffc8295e657030357ab74d799a5abb79c54a2ca558485d5449fd467e838526b4023e7026*) bobshell_die "expected to die: $*" ;;
	esac
}

assert_file_exists() {
	if [ ! -f "$1" ]; then
		assertion_error "file expected to exist: $1"
	fi
}

assert_file_contents() {
	_assert_file_contains=$(cat "$2")
	if [ "$1" != "$_assert_file_contains" ]; then
		assertion_error "actual file ($2) contents <$_assert_file_contains> expected to be equal to <$1>${3:+ $3}"
	fi
}
