
shelduck import base.sh


bobshell_require_isset_1() {
	if ! bobshell_isset_1 "$@"; then
		bobshell_die '%s: ' "${*:-argument 1 required to be set}"
	fi
}

bobshell_require_isset_2() {
	if ! bobshell_isset_2 "$@"; then
		bobshell_die '%s: ' "${*:-argument 2 required to be set}"
	fi	
}

bobshell_require_isset_3() {
	if ! bobshell_isset_3 "$@"; then
		bobshell_die '%s: ' "${*:-argument 3 required to be set}"
	fi	
}

bobshell_require_file_exists() {
	if [ ! -e "$1" ]; then
		printf '%s: no such file\n' "$1"
		return 1
	fi
}

bobshell_require_not_empty() {
	if [ -z "$1" ]; then
		bobshell_die '%s: ' "${*:value required not to be empty}"
	fi
}