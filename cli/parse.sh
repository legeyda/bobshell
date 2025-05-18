
shelduck import ../base.sh
shelduck import ../result/check.sh
shelduck import ../result/set.sh
shelduck import ../event/fire.sh


# fun: bobshell_cli_parse SCOPE [args...]
# use: bobshell_cli_parse hoid_task_user_cli "$@"
#      bobshell_array_call bobshell_result set --
bobshell_cli_parse() {
	bobshell_cli_shift=0
	_bobshell_cli_parse__scope="$1"
	shift

	bobshell_event_fire "${_bobshell_cli_parse__scope}_start"

	while bobshell_isset_1 "$@"; do
		if [ "$1" = -- ]; then
			bobshell_cli_shift=$(( bobshell_cli_shift + 1 ))
			shift
			break
		fi

		bobshell_result_set false
		bobshell_event_fire "${_bobshell_cli_parse__scope}_arg" "$@"
		if bobshell_result_check _bobshell_cli_parse__shift; then
			bobshell_cli_shift=$(( bobshell_cli_shift + _bobshell_cli_parse__shift ))
			shift "$_bobshell_cli_parse__shift"
			unset _bobshell_cli_parse__shift
			continue
		fi

		if [ "$1" = - ]; then
			bobshell_die "bobshell_cli_parse: $_bobshell_cli_parse__scope: unexpected argument:2 $1"
		fi


		if bobshell_starts_with "$1" -; then
			_bobshell_cli_parse__arg="$1"
			bobshell_cli_shift=$(( bobshell_cli_shift + 1 ))
			shift
			_bobshell_cli_parse__rest="${_bobshell_cli_parse__arg#?}"
			while [ -n "$_bobshell_cli_parse__rest" ]; do
				_bobshell_cli_parse__tail="${_bobshell_cli_parse__rest#?}"
				_bobshell_cli_parse__head="${_bobshell_cli_parse__rest%$_bobshell_cli_parse__tail}"
				
				bobshell_result_set false
				if [ -n "$_bobshell_cli_parse__tail" ]; then
					bobshell_event_fire "${_bobshell_cli_parse__scope}_arg" "-$_bobshell_cli_parse__head"
					if ! bobshell_result_check; then
						bobshell_die "bobshell_cli_parse: $_bobshell_cli_parse__scope: unexpected argument: $_bobshell_cli_parse__arg"
					fi
				else
					bobshell_event_fire "${_bobshell_cli_parse__scope}_arg" "-$_bobshell_cli_parse__head" "$@"
					if bobshell_result_check _bobshell_cli_parse__shift; then
						bobshell_cli_shift=$(( bobshell_cli_shift + _bobshell_cli_parse__shift - 1 ))
						shift $(( _bobshell_cli_parse__shift - 1 ))
						unset _bobshell_cli_parse__shift
					else
						bobshell_die "bobshell_cli_parse: $_bobshell_cli_parse__scope: unexpected argument: $_bobshell_cli_parse__arg"
					fi
				fi
				_bobshell_cli_parse__rest="$_bobshell_cli_parse__tail"
			done
			unset _bobshell_cli_parse__arg _bobshell_cli_parse _bobshell_cli_parse__tail _bobshell_cli_parse__head
			continue
		fi

		break


	done
	bobshell_result_set true "$@"

	unset _bobshell_cli_parse__scope
}
