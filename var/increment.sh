

bobshell_var_increment() {
	eval "$1"'=$(( '"$1"' + 1 ))'
}