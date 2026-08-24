
shelduck import ./set.sh
shelduck import ./isset.sh


bobshell_result_shift() { # todo arg
	set -- "${1:-1}"

	if [ "$1" -lt 1 ]; then
		bobshell_die 'bobshell_result_shift: index must be greater than 0'
	fi

	if ! bobshell_result_isset; then
		bobshell_die 'bobshell_result_shift: result is not set'
	fi

	if [ "$1" -ge "$bobshell_result_size" ]; then
		bobshell_result_set
		return
	fi

	for _bobshell_result_shift__i in $(seq $(( bobshell_result_size - $1 )) ); do
		eval bobshell_result_"$_bobshell_result_shift__i"'="$bobshell_result_'"$(( _bobshell_result_shift__i + $1 ))"'"'	
	done

	for _bobshell_result_shift__j in $(seq $(( _bobshell_result_shift__i + 1)) "$bobshell_result_size" ); do
		unset bobshell_result_"$_bobshell_result_shift__j"
	done
	unset _bobshell_result_shift__j

	bobshell_result_size="$_bobshell_result_shift__i"
	unset _bobshell_result_shift__i
}