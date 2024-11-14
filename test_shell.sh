#!/bin/sh
set -eu

shelduck --alias die   base.sh
shelduck assert.sh
shelduck string.sh


test_shell() {
	# assert_empty         "$(Y=$(echo hello; die); echo "$Y")" # as expected: nothing printed
	# assert_not_empty "$(echo "$(echo hello; die)")" # strange: value printed after exit
	# assert_empty "$(: "${Z:=$(die)}"; echo "$Z")"

	# assert_error invoke_self eval 'alias run_test_alias_for_echo=echo; run_test_alias_for_echo'
	# assert_equals hello "$(invoke_self eval 'run_test_alias_for_echo() { echo "$@"; }; run_test_alias_for_echo hello')"
	# assert_equals hello "$(invoke_self eval 'superalias run_test_alias_for_echo=echo; run_test_alias_for_echo hello')"

	# todo
	# grep inside pipe
	
	
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

}

test_set_e() {
	# without set -e
	sh -c 'false; printf %s this should not have been printed; true' || die ok expected

	# with set -e
	sh -c 'set -e; false; true' && die error expected || true
}

test_command() {
	#
	assert_error sh -c 'set -e; x=$(false); printf %s s'

	# todo
	#assert_ok sh -c 'set -e; x=$(false); printf %s s'


}

test_xxx() {

f() {
	cat <<eof
"$@"
eof
}

	result=$(bobshell_quote "1 '2 3'")
	result=$(eval "printf %s $result")
	assert_equals "1 '2 3'" "$result"
}
