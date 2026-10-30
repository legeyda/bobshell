
shelduck import ./lstrip.sh
shelduck import ./rstrip.sh
shelduck import ../result/set.sh


bobshell_str_strip() {
	bobshell_str_lstrip "$@"
	_bobshell_str_strip__left="$bobshell_result_1"
	shift
	set -- "$bobshell_result_2" "$@"

	bobshell_str_rstrip "$@"
	bobshell_result_set_3 "$_bobshell_str_strip__left" "$bobshell_result_1" "$bobshell_result_2"
	unset _bobshell_str_strip__left
}
