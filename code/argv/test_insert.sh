
shelduck import ../../assert.sh
shelduck import insert.sh

test_insert() {
	# shellcheck disable=SC2016
	assert_equals '_bobshell_code_argv_insert__1="$1"
_bobshell_code_argv_insert__2="$2"
_bobshell_code_argv_insert__3="$3"
shift 3
set -- "$_bobshell_code_argv_insert__1" "$_bobshell_code_argv_insert__2" "$_bobshell_code_argv_insert__3" "hello" "$@"
unset _bobshell_code_argv_insert__1 _bobshell_code_argv_insert__2 _bobshell_code_argv_insert__3' \
			"$(bobshell_code_argv_insert 3 '"hello"')"
}