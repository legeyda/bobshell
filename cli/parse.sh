
shelduck import ../base.sh
shelduck import ../result/check.sh
shelduck import ../result/set.sh
shelduck import ../event/fire.sh
shelduck import ../misc/equals_any.sh

shelduck import ./help.sh

# fun: bobshell_cli_parse SCOPE [args...]
# use: bobshell_cli_parse hoid_task_user_cli "$@"
#      bobshell_array_call bobshell_result set --
bobshell_cli_parse() {
	bobshell_cli_shift=0
	_bobshell_cli_parse__scope="$1"
	shift

	bobshell_var_get "$_bobshell_cli_parse__scope"_params
	if ! bobshell_result_check _bobshell_cli_parse__params; then
		_bobshell_cli_parse__params=
	fi

	bobshell_var_get "$_bobshell_cli_parse__scope"_flags
	if ! bobshell_result_check _bobshell_cli_parse__flags; then
		_bobshell_cli_parse__flags=
	fi



	bobshell_event_fire "${_bobshell_cli_parse__scope}_start_event"

	while bobshell_isset_1 "$@"; do
		# -- end of named options, start of positional arguments
		if [ "$1" = -- ]; then
			bobshell_cli_shift=$(( bobshell_cli_shift + 1 ))
			shift
			break
		fi

		# obvious error
		if [ "$1" = - ]; then
			bobshell_cli_parse__error "unexpected argument: $1"
		fi
		
		# 
		if bobshell_remove_prefix "$1" -- _bobshell_cli_parse__x; then
			if bobshell_split_first "$_bobshell_cli_parse__x" '=' _bobshell_cli_parse__name _bobshell_cli_parse__value; then
				# shellcheck disable=SC2086
				if ! bobshell_equals_any "$_bobshell_cli_parse__name" $_bobshell_cli_parse__params; then
					bobshell_cli_parse__error "unknown param: --$_bobshell_cli_parse__name"
				fi
				bobshell_event_fire "$_bobshell_cli_parse__scope"_arg_event "$_bobshell_cli_parse__name" "$_bobshell_cli_parse__value"
				bobshell_cli_shift=$(( bobshell_cli_shift + 1 ))
				shift
				unset _bobshell_cli_parse__name _bobshell_cli_parse__value
			else
				# shellcheck disable=SC2086
				if bobshell_equals_any "$_bobshell_cli_parse__x" $_bobshell_cli_parse__params; then
					if ! bobshell_isset_2 "$@"; then
						bobshell_cli_parse__error "param argument expected: $1"
					fi
					bobshell_event_fire "$_bobshell_cli_parse__scope"_arg_event "$_bobshell_cli_parse__x" "$2"
					bobshell_cli_shift=$(( bobshell_cli_shift + 2 ))
					shift 2
				elif bobshell_equals_any "$_bobshell_cli_parse__x" $_bobshell_cli_parse__flags; then
					bobshell_event_fire "$_bobshell_cli_parse__scope"_arg_event "$_bobshell_cli_parse__x"
					bobshell_cli_shift=$(( bobshell_cli_shift + 1 ))
					shift
				else
					bobshell_cli_parse__error "unkonwn arg: $1"
				fi
			fi
			unset _bobshell_cli_parse__x
		elif bobshell_remove_prefix "$1" - _bobshell_cli_parse__x; then
			while [ -n "$_bobshell_cli_parse__x" ]; do
				_bobshell_cli_parse__rest="${_bobshell_cli_parse__x#?}"
				_bobshell_cli_parse__arg="${_bobshell_cli_parse__x%"$_bobshell_cli_parse__rest"}"
				# shellcheck disable=SC2086
				if bobshell_equals_any "$_bobshell_cli_parse__arg" $_bobshell_cli_parse__params; then
					if [ -n "$_bobshell_cli_parse__rest" ]; then
						bobshell_event_fire "${_bobshell_cli_parse__scope}_arg_event" "$_bobshell_cli_parse__arg" "$_bobshell_cli_parse__rest"
						bobshell_cli_shift=$(( bobshell_cli_shift + 1 ))
						shift
						break
					elif bobshell_isset_2 "$@"; then
						if ! bobshell_isset_2 "$@"; then
							bobshell_cli_parse__error "param argument expected: $1"
						fi
						bobshell_event_fire "${_bobshell_cli_parse__scope}_arg_event" "$_bobshell_cli_parse__arg" "$2"
						bobshell_cli_shift=$(( bobshell_cli_shift + 2 ))
						shift 2
						break
					else
						bobshell_cli_parse__error "unknown argument: -$_bobshell_cli_parse__arg"
					fi
				elif bobshell_equals_any "$_bobshell_cli_parse__arg" $_bobshell_cli_parse__flags; then
					bobshell_event_fire "${_bobshell_cli_parse__scope}_arg_event" "$_bobshell_cli_parse__arg"
					if [ -z "$_bobshell_cli_parse__rest" ]; then
						bobshell_cli_shift=$(( bobshell_cli_shift + 1 ))
						shift
					fi
				else
					bobshell_cli_parse__error "unknown argument: -$_bobshell_cli_parse__arg"
				fi
				_bobshell_cli_parse__x="$_bobshell_cli_parse__rest"
			done
			unset _bobshell_cli_parse__x
		else
			break
		fi
	done
	unset _bobshell_cli_parse__scope _bobshell_cli_parse__params _bobshell_cli_parse__flags

	bobshell_result_set true "$@"
}

bobshell_cli_parse__error() {
	_bobshell_cli_parse__error__message=$(bobshell_cli_help "$_bobshell_cli_parse__scope")
	_bobshell_cli_parse__error__message="bobshell_cli_parse $_bobshell_cli_parse__scope: $*

$_bobshell_cli_parse__error__message"
	bobshell_die "$_bobshell_cli_parse__error__message"
}