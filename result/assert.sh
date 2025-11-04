
shelduck import ./read.sh
shelduck import ./check.sh
shelduck import ./apply.sh


bobshell_result_assert() {
	if ! bobshell_result_check "$@"; then
		bobshell_result_apply set --
		if bobshell_isset_1 "$@"; then
			shift
		fi
		bobshell_die "$@" 
	fi
}
