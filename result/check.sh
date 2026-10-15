
shelduck import ../resource/copy.sh

bobshell_result_check() {
	if [ "${bobshell_result_size:-0}" -gt 0 ]; then
		case "${bobshell_result_1:-}" in
			(true)  ;;
			(false) return 1 ;;
			(*) bobshell_die "bobshell_result_check: error parsing result as boolean: $bobshell_result_1"
		esac
	else
		bobshell_die "bobshell_result_check: no result"
	fi

	if ! [ "$#" -lt "$bobshell_result_size" ]; then
		return 1 # not enough vars
	fi

	_bobshell_result_check__i=2
	while [ "$#" -gt 0 ] ; do
		if [ -n "$1" ] && [ - != "$1" ]; then
			eval "$1"'="$bobshell_result_'"$_bobshell_result_check__i"'"'
		fi
		_bobshell_result_check__i=$(( _bobshell_result_check__i + 1 ))
		shift
	done
	unset _bobshell_result_check__i
}
