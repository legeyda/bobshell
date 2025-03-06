
shelduck import ../base.sh

bobshell_result_ok() {
	bobshell_result_code=0
	if bobshell_isset_1 "$@"; then
		bobshell_result_value="$*"
	else
		unset bobshell_result_value
	fi
}
