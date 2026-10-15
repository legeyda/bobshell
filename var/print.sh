
shelduck import ../base.sh
shelduck import ../misc/log.sh


bobshell_var_print() {
	if [ $# -eq 1 ]; then
		eval 'printf %s "$'"$1"'"'
	elif [ $# -gt 1 ]; then
		_bobshell_var_print='printf "$1"'
		shift
		while [ $# -gt 0 ]; do
			_bobshell_var_print="$_bobshell_var_print"' "$'"$1"'"'
		done
		eval "$_bobshell_var_print"
		unset _bobshell_var_print
	else
		bobshell_log_error "bobshell_var_print: neither variable $1 set nor default value provided"
		return 1
	fi
}
