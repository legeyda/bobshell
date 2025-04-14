
shelduck import ../base.sh
shelduck import ../result/set.sh

bobshell_var_get() {
	if bobshell_isset "$1"; then
		eval "bobshell_result_set true \"\$$1\""
	elif bobshell_isset_2 "$@"; then
		eval bobshell_result_set true "$2"
	else
		bobshell_result_set false
	fi
}