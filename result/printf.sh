


bobshell_result_printf() {
	# shellcheck disable=SC2183
	_bobshell_result_prinft=$(printf "$@")
	bobshell_result="${bobshell_result:-}$_bobshell_result_prinft"
	unset _bobshell_result_prinft
}
