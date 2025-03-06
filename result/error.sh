
bobshell_result_error() {
	bobshell_result_code=1
	unset bobshell_result_value
	bobshell_result_message="$*"
	if [ -z "$bobshell_result_message" ]; then
		bobshell_result_message='unknown error'
	fi
}
