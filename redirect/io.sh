
shelduck import ./input.sh
shelduck import ./output.sh


# todo unstable

# fun: bobshell_redirect INPUT OUTPUT COMMAND [ARGS...]
bobshell_redirect_io() {
	if [ stdin: = "$1" ]; then
		if [ stdout: = "$2" ]; then
			shift 2
			"$@"
		else
			shift
			bobshell_redirect_output "$@"
		fi
	elif [ stdout: = "$2" ]; then
		_bobshell_redirect_io__src="$1"
		shift 2
		set -- "$_bobshell_redirect_io__src" "$@"
		unset _bobshell_redirect_io__src
		bobshell_redirect_input "$@"
	else
		_bobshell_redirect_io__src="$1"
		shift
		set -- bobshell_redirect_input "$_bobshell_redirect_io__src" bobshell_redirect_output "$@"
		unset _bobshell_redirect_io__src
		"$@"
	fi
}
