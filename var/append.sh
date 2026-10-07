
shelduck import ../base.sh
shelduck import ../result/assert.sh
shelduck import ../result/set.sh
shelduck import ./get.sh
shelduck import ./set.sh

bobshell_var_append() {
	_bobshell_var_append__var="$1"
	shift

	bobshell_var_get "$_bobshell_var_append__var"
	bobshell_result_assert _bobshell_var_append__value -- bobshell_var_append: var "$_bobshell_var_append__var" not set

	_bobshell_var_append__value="$_bobshell_var_append__value$*"
	bobshell_var_set "$_bobshell_var_append__var" "$_bobshell_var_append__value"
	unset _bobshell_var_append__var
	bobshell_result_set true "$_bobshell_var_append__value"
	unset _bobshell_var_append__value
}
