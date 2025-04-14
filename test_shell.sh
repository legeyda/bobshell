
shelduck import --alias die   base.sh
shelduck import assert.sh
shelduck import string.sh


test_output_redirection() {
	x=1
	y=$(printf %s hello; x=2)
	assert_equals 1 "$x" # no side effect!
	assert_equals hello "$y"

	x=$(printf '%s\n' hello)
	assert_equals hello "$x" # no trailing newline!

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

test_for() {
	# it is ok to unset variable inside for loop
	x=$(print_args_unset 1 2 3)
	assert_equals 123 "$x"
}

print_args_unset() {
	for x in "$@"; do
		set -- x "$@"
		printf %s "$x"
		unset x
	done
}


test_var() {
	y=
	x=$(y=1; printf %s hello)
	assert_equals hello "$x"
	assert_empty "$y"

	x=
	y=
	x=1 y=1 eval echo hello
	assert_equals 1 "$x"
	assert_equals  1 "$y"
}

f() {
	x=
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


test_yyy() {
	set -eu
	#function_with_error
	echo i am here
	if function_with_error; then
		echo 'expected to error' >&2
	fi




}

function_with_error() {
	function_does_not_exist 1 2 3
	printf %s hello from function_with_error
}

test_assign_error() {
	unset x
	assert_ok eval 'x=$(printf %s hello; return 0)'
	assert_equals hello "$x"

	unset x
	assert_error eval 'x=$(printf %s hello; return 1)'
	assert_isset x # !!!
}

test_zero_arg() {
	assert_equals sh "$(sh -c 'echo $0')"
	assert_equals z "$(sh -c 'echo $0' z)"
	assert_equals 'z 1 2 3' "$(sh -c 'echo $0 $@' z 1 2 3)"

	mkdir -p target/test_zero_arg
	cd target/test_zero_arg
	# shellcheck disable=SC2016
	echo '#!/usr/bin/env sh
echo "$0" "$@"
' > script
	chmod +x script
	assert_equals ./script "$(./script)"
	assert_equals "$(realpath ./script)" "$($(realpath ./script))"
	assert_equals './script z 1 2 3' "$(./script z 1 2 3)"
}

test_catch_output_side_effect() {
	unset f
	x=$(f hello)
	assert_equals hello "$x"
	assert_unset f
}

f() {
	if bobshell_isset_1 "$@"; then
		printf %s "$*"
	else
		cat
	fi
	f=hello
}

test_pipe_side_effect() {
	unset f
	echo hello | f
	assert_unset f
}

test_output_file_side_effect() {
	t=$(mktemp -d)
	unset f
	f hello > "$t/out"
	assert_equals hello "$(cat "$t/out")"
	assert_isset f

}

