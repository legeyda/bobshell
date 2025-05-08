

shelduck import ../base.sh
shelduck import ../event/listen.sh

# fun: bobshell_cli_default SCOPE VARNAME DEFAULT
bobshell_cli_default() {
	if bobshell_isset_3 "$@"; then
		_bobshell_cli_default__quote=$(bobshell_quote "$3")
		bobshell_event_listen "${1}_start" "$2=$_bobshell_cli_default__quote"
		unset _bobshell_cli_default__quote
	else
		bobshell_event_listen "${1}_start" "unset $2"
	fi
}
