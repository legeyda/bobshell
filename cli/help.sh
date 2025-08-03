




bobshell_cli_help() {
	printf '%s\n' "Usage: bobshell_cli_parse $1 [OPTIONS] ARGS

Options:"
	bobshell_event_fire "$1"_help_event

}