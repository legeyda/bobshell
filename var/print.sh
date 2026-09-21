
shelduck import ../base.sh
shelduck import ../misc/log.sh


bobshell_var_print() {
	if bobshell_isset "$1"; then
		eval 'printf %s "$'"$1"'"'
	elif [ $# -gt 1 ]; then
		printf %s "$2"
	else
		bobshell_log_error "bobshell_var_print: neither variable $1 set nor default value provided"
		return 1
	fi
}
