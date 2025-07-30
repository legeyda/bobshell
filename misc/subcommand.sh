
shelduck import ../base.sh

bobshell_subcommand() {
	_bobshell_subcommand=$(printf %s "$2" | tr - _)
	_hoid_util_subcommand__function="${1}_$_bobshell_subcommand"
	unset _bobshell_subcommand
	if ! bobshell_command_available "$_hoid_util_subcommand__function"; then
		bobshell_die "bobshell_subcommand: unknown subcommand: $2 (function $_hoid_util_subcommand__function not available)"
	fi
	shift 2

	"$_hoid_util_subcommand__function" "$@"
	unset _hoid_util_subcommand__function
}