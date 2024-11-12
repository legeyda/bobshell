#!/bin/sh
set -eu

#. ./string.sh
. ./mock_shelduck.sh
shelduck ./base.sh
shelduck ./assert.sh

# shellcheck disable=SC2120
die() {
	bobshell_die "$@"
}

test_shell() {
	# assert_empty         "$(Y=$(echo hello; die); echo "$Y")" # as expected: nothing printed
	# assert_not_empty "$(echo "$(echo hello; die)")" # strange: value printed after exit
	# assert_empty "$(: "${Z:=$(die)}"; echo "$Z")"

	# assert_error invoke_self eval 'alias run_test_alias_for_echo=echo; run_test_alias_for_echo'
	# assert_equals hello "$(invoke_self eval 'run_test_alias_for_echo() { echo "$@"; }; run_test_alias_for_echo hello')"
	# assert_equals hello "$(invoke_self eval 'superalias run_test_alias_for_echo=echo; run_test_alias_for_echo hello')"

	# todo
	# grep inside pipe
	
	# without set -e
	sh -c 'false; true' || die ok expected

	# with set -e
	sh -c 'set -e; false; true' && die error expected || true
	
	# grep return nonzero status code when nothing found
	output=$(sh -c 'set -e; x=$(printf hello | grep x); echo hi' && error expected || true)
	assert_empty "$output" hi is not printed

	output=$(sh -c 'set -e; x=$(printf hello | grep x || true); echo hi' || die ok expected)
	assert_equals hi "$output"

	# 

	unset -f fun
	fun() {
		set -- "$(printf hello; die in printf)"

	}

	success
}

test_xxx() {
	echo i am here
}


test_shell
test_xxx


shelduck unittest.sh

echo "ZERO IS $bobshell_script_path"