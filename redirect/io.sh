
shelduck import ./input.sh
shelduck import ./output.sh

# fun: bobshell_redirect INPUT OUTPUT COMMAND [ARGS...]
bobshell_redirect_io() {
	_bobshell_redirect_io__src="$1"
	_bobshell_redirect_io__dest="$2"
	shift 2
	bobshell_redirect_input "$_bobshell_redirect_io__src" bobshell_redirect_output "$_bobshell_redirect_io__dest" "$@"
	unset _bobshell_redirect_io__src _bobshell_redirect_io__dest
}