
shelduck import ../string.sh
shelduck import ./check.sh

bobshell_result_assert() {
	if ! bobshell_result_check; then
		_bobshell_result_assert__message=$(bobshell_join ': ' "$*" "$bobshell_result_message")
		bobshell_die "$_bobshell_result_assert__message"
	fi
}