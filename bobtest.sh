
shelduck import base.sh
shelduck import string.sh

bobtest() {
	stdout_file=$(mktemp)
	stderr_file=$(mktemp)
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
	if ! BOBTEST_FILE="$1" BOBTEST_FUNCTION="$2" \
			bobtest_run "$@" > "$stdout_file" 2> "$stderr_file"; then
		printf 'failure\n\n'
		printf '\n\nSTDOUT WAS:\n%s\n'
		cat "$stdout_file"
		
		printf '\n\nSTDERR WAS:\n%s\n'
		cat "$stderr_file"
		
		exit
	fi
	printf ' ok\n'
}

# fun: bobtest_run FILE FUNCTIION
# env: 
bobtest_run() {
	: "${BOBTEST_RUN:=bobtest_shelduck_run}"
	"$BOBTEST_RUN" "$@"
}

bobtest_shelduck_run() {
	sh -c "shelduck_run 'val:shelduck import \"file://$1\"; set -eux; $2'"
}
