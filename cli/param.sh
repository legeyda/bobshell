

shelduck import ../base.sh
shelduck import ../result/set.sh
shelduck import ../event/listen.sh

# fun: bobshell_cli_param SCOPE VARNAME [ARGS...]
bobshell_cli_param() {
	_bobshell_cli_param__scope="$1"
	_bobshell_cli_param__var="$2"
	shift 2

	while bobshell_isset_1 "$@"; do
		if [ 1 = "${#1}" ]; then
			_bobshell_cli_param__arg="-$1"
		else
			_bobshell_cli_param__arg="--$1"
		fi

		# shellcheck disable=SC2016
		bobshell_event_listen "${_bobshell_cli_param__scope}_arg" '
	if [ "$1" = '"$_bobshell_cli_param__arg"' ]; then
		bobshell_isset_2 "$@" || bobshell_die argument expected
		'"$_bobshell_cli_param__var"'="$2"
		bobshell_result_set true 2
		return
	fi
	if bobshell_remove_prefix "$1" '"$_bobshell_cli_param__arg"'= '"$_bobshell_cli_param__var"'; then
		bobshell_result_set true 1
		return
	fi'
		shift
	done

	bobshell_event_listen "${_bobshell_cli_param__scope}_clear" "unset $_bobshell_cli_param__var"

	unset _bobshell_cli_param__scope _bobshell_cli_param__var
}