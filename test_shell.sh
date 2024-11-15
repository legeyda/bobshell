#!/bin/sh
set -eu

shelduck import --alias die   base.sh
shelduck import assert.sh
shelduck import string.sh


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
	assert_ok sh -c 'false; printf %s this should not have been printed; true'

	# with set -e
	assert_error sh -c 'set -e; false; true'


	str=hello
	str=$(sh -c 'set -e; x=$(false); printf hello' || true)
	assert_empty "$str" 
	
	str=$(sh -c 'set -e; for x in $(false); do echo $x; done; printf hello')
	assert_equals hello "$str" 

	str=
	str=$(sh -c 'set -e; printf %s "$(false || exit 1)"; printf hello')
	assert_equals hello "$str" 

	# printf %s "$(exit_on_error false; printf hello)" 
	
	# exit_on_error false
	
	# echo i am here
	# die debug
}

exit_on_error() {
	"$@" || exit $?
}

test_command() {
	#
	assert_error sh -c 'set -e; x=$(false); printf %s s'

	# todo
	#assert_ok sh -c 'set -e; x=$(false); printf %s s'


}



BOBSHELL_MAIN_PID=$PPID
export BOBSHELL_MAIN_PID
is_subshell() {
	test $PPID != $BOBSHELL_MAIN_PID
}

print_is_subshell() {
	is_subshell && printf subshell || printf no_subshell
}

test_subshell() {
	assert_error is_subshell
	
	# 
	str=$(  (print_is_subshell)   )
	assert_equals no_subshell "$str"

	str=$(print_is_subshell)
	assert_equals no_subshell "$str"

	str=$(true; true; true; git --version > /dev/null; print_is_subshell)
	assert_equals no_subshell "$str"

	x=1
	str=$(printf hello; x=2)
	assert_equals 1 "$x"

	str="hello_$(print_is_subshell)"
	assert_equals hello_no_subshell "$str"

	x=1
	str="hello_$(printf hello; x=2)"
	assert_equals 1 "$x"


	str=$(VAR=x; VAR=hi print_is_subshell; printf %s $VAR)
	assert_equals 'no_subshellx' "$str"

	str=$(echo hello | print_is_subshell)
	assert_equals no_subshell "$str"


	# #
	# str="hello-$()"

	# #
	# str=$(echo "$()")


}




_test_xxx() {

f() {
	cat <<eof
"$@"
eof
}

	result=$(bobshell_quote "1 '2 3'")
	result=$(eval "printf %s $result")
	assert_equals "1 '2 3'" "$result"
}
