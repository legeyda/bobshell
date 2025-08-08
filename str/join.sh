
shelduck import ../base.sh
shelduck import ../result/set.sh

bobshell_str_join() {
	_bobshell_str_join__separator="$1"
	shift
	if ! bobshell_isset_1 "$@"; then
		bobshell_result_set ''
		return
	fi
	bobshell_result_set "$1"
	shift
	while bobshell_isset_1 "$@"; do
		bobshell_result_1="$bobshell_result_1$_bobshell_str_join__separator$1"
		shift
	done
}