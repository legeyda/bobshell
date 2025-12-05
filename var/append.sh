
shelduck import ../base.sh
shelduck import ../result/check.sh
shelduck import ../result/set.sh
shelduck import ./get.sh
shelduck import ./set.sh

bobshell_var_append() {
	bobshell_var_get "$1"
	if ! bobshell_result_check _bobshell_var_append__value; then
		return
	fi
	_bobshell_var_append__value="$_bobshell_var_append__value$2"
	bobshell_var_set "$1" "$_bobshell_var_append__value"
	bobshell_result_set true "$_bobshell_var_append__value"
	unset _bobshell_var_append__value
}


