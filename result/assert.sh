
shelduck import ./assert.sh

bobshell_result_assert() {
	if ! bobshell_result_check; then
		bobshell_die "$@"
	fi
}