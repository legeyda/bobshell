

bobshell_var_decrement() {
	eval "$1"'=$(( '"$1"' - 1 ))'
}