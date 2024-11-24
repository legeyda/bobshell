
shelduck import base.sh


bobshell_require_isset_1() {
	if ! bobshell_isset_1 "$1"; then
		bobshell_die '%s: ' "${*:-argument required to be set}"
	fi	
}