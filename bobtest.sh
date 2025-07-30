
shelduck import base.sh
shelduck import string.sh

bobtest() {
	bobshell_stdout_file=$(mktemp)
	bobshell_stderr_file=$(mktemp)
	file_separator=
	if bobshell_isset_1 "$@"; then
		while bobshell_isset_1 "$@"; do
			bobtest_file_or_dir "$1"
			shift
		done
	else
		bobtest_dir '.'
	fi
}

bobtest_file_or_dir() {
	if [ -d "$1" ]; then
		bobtest_dir "$@"
	else
		bobtest_file "$@"
	fi
}

bobtest_dir() {
	_bobtest_dir__find=$(find "$1" -path '*/.*' -prune -o -name 'test_*.sh' -printf "bobtest_file '$1/%P'\n")
	eval "$_bobtest_dir__find"
	unset _bobtest_dir__find 
}

# fun: bobtest_test_file SCRIPT[:FUNCTION]
bobtest_file() {
	printf %s "$file_separator"
	_bobtest_file="$1"
	unset _bobtest_file__function
	bobshell_split_first "$_bobtest_file" : _bobtest_file _bobtest_file__function || true

	_bobtest_file_real_path=$(realpath "$_bobtest_file")
	printf 'file %s:\n' "$_bobtest_file"
	if [ -n "${_bobtest_file__function:-}" ]; then
		bobtest_file_function "$_bobtest_file_real_path" "$_bobtest_file__function"
	else
		all__bobtest_file__functions=$(sed -n --regexp-extended 's/^( *function)? *(test_\w+) *\( *\) *\{ *$/\2/pg' "$_bobtest_file_real_path")
		if [ -z "$all__bobtest_file__functions" ]; then
			echo "no test_* function found in file $_bobtest_file"
		fi
		for _bobtest_file__function in $all__bobtest_file__functions; do
			bobtest_file_function "$_bobtest_file_real_path" "$_bobtest_file__function"
		done
	fi
	file_separator="$bobshell_newline"
}

# fun: bobtest_file_function SCRIPT FUNCTION
bobtest_file_function() {
	bobshell_basic_regex_match "$2" '^[A-Za-z_][A-Za-z_0-9]*$' || bobshell_die "wrong function name: $2"

	printf '  function %s... ' "$2"

	bobtest_file_function_run "$@"
	if ! bobshell_result_check; then
		printf 'failure\n\n'
		if [ true = "${BOBTEST_REDIRECT:-true}" ]; then
			printf '\n\nSTDOUT WAS:\n%s\n'
			cat "$bobshell_stdout_file"
			
			printf '\n\nSTDERR WAS:\n%s\n'
			cat "$bobshell_stderr_file"
		else
			echo "stdin and stdout see above"
		fi
		
		return 1
	fi
	printf ' ok\n'
}


bobtest_output_flag=6b2e8ddb5198464ea952c131e17bfede9966f038c958468e8ec5108d2ed7765ed707be73346a471a8b6e9526b65060c989c28249af4e475d9c80f3e501251079


# fun: bobtest_run FILE FUNCTIION
# env: 
bobtest_file_function_run() {
	: "${BOBTEST_RUN:=bobtest_run}"

	_bobtest_file_function_run__script='( set -eu; printf %s "$(set -eux; "$BOBTEST_RUN" "$@"; printf %s "$bobtest_output_flag")" )'
	if [ true = "${BOBTEST_REDIRECT:-true}" ]; then
		_bobtest_file_function_run__script="$_bobtest_file_function_run__script"' > "$bobshell_stdout_file" 2> "$bobshell_stderr_file"'
	fi
	eval "$_bobtest_file_function_run__script"
	unset _bobtest_file_function_run__script
	 
	
	if grep -q "$bobtest_output_flag" "$bobshell_stdout_file"; then
		bobshell_result_set true	
	else
		bobshell_result_set false
	fi
	
	unset _bobtest_run_output
}

bobtest_run() {
	export BOBTEST_FILE="$1"
	export BOBTEST_FUNCTION="$2"

	_bobtest_run__script=$(shelduck resolve "file://$1")
	_bobtest_run__script="$_bobtest_run__script

set -x
$2"

	if [ "${#_bobtest_run__script}" -lt 100000 ]; then
		${BOBTEST_SHELL_COMMAND:-sh -eu} -c "$_bobtest_run__script"
	else
		_bobtest_run__file=$(mktemp)
		printf %s "$_bobtest_run__script" > "$_bobtest_run__file"
		${BOBTEST_SHELL_COMMAND:-sh -eu} "$_bobtest_run__file"
		rm -r "$_bobtest_run__file"
		unset _bobtest_run__file
	fi
	
	unset _bobtest_run__script
}
