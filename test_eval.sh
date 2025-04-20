
shelduck import ./assert.sh
shelduck import ./eval.sh

test_val() {
	x=$(bobshell_eval 'printf "[%s] " "$@"' 1 2 3)
	assert_equals '[1] [2] [3] ' "$x"


	x=$(bobshell_eval 'printf "[%s] " "$3" "$2" "1" ' 1 2 3)
	assert_equals '[3] [2] [1] ' "$x"
}

test_var() {
	x='printf "[%s] " "$@"'
	x=$(bobshell_eval var:x 1 2 3)
	assert_equals '[1] [2] [3] ' "$x"

	#shellcheck disable=SC2016
	x='printf "[%s] " "$3" "$2" "$1"'
	x=$(bobshell_eval var:x 1 2 3)
	assert_equals '[3] [2] [1] ' "$x"
}

test_file() {
	t=$(mktemp)
	echo 'printf "[%s] " "$@"' > "$t"
	x=$(bobshell_eval "file:$t" 1 2 3)
	assert_equals '[1] [2] [3] ' "$x"

	#shellcheck disable=SC2016
	echo 'printf "[%s] " "$3" "$2" "$1"' > "$t"
	x=$(bobshell_eval "file:$t" 1 2 3)
	assert_equals '[3] [2] [1] ' "$x"
}