
shelduck import ../base.sh
shelduck import ../result/set.sh

bobshell_var_default() {
	if ! bobshell_isset "$1"; then
		bobshell_var_set "$@"
	fi
}