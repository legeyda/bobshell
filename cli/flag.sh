

shelduck import ../base.sh
shelduck import ../result/set.sh
shelduck import ../event/listen.sh

# use: bobshell_cli_flag SCOPE VARNAME VALUE [ARGS...]
bobshell_cli_flag() {

	_bobshell_cli_flag__scope="$1"
	_bobshell_cli_flag__var="$2"
	_bobshell_cli_flag__quoted_value=$(bobshell_quote "$3")
	shift 3

	while bobshell_isset_1 "$@"; do
		if [ 1 = "${#1}" ]; then
			_bobshell_cli_flag__arg="-$1"
		else
			_bobshell_cli_flag__arg="--$1"
		fi

		# shellcheck disable=SC2016
		bobshell_event_listen "${_bobshell_cli_flag__scope}_arg" '
	if [ "$1" = '"$_bobshell_cli_flag__arg"' ]; then
		'"$_bobshell_cli_flag__var"'='"$_bobshell_cli_flag__quoted_value"'
		bobshell_result_set true 1
		return
	fi'
		shift
	done

	# shellcheck disable=SC1073
	bobshell_event_listen "${_bobshell_cli_flag__scope}_clear" "unset $_bobshell_cli_flag__var"

	unset _bobshell_cli_flag__scope _bobshell_cli_flag__var _bobshell_cli_flag__quoted_value
}
