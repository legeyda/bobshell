
shelduck import ./input.sh
shelduck import ./output.sh

# fun: bobshell_redirect INPUT OUTPUT COMMAND [ARGS...]
bobshell_redirect_io() {
	_bobshell_redirect_io__src="$1"
	shift
	bobshell_redirect_input "$_bobshell_redirect_io__src" bobshell_redirect_output "$@"
	unset _bobshell_redirect_io__src
}