
shelduck import base.sh

main() {
	if [ -z "${1:-}" ]; then
		run_usage >&2
	fi
	bobshell_main "$@"
}

bobshell_main() {
	bobshell_handle_subcommand "$@"
}

bobshell_handle_subcommand() {
	if [ -z "${1:-}" ]; then
		return
	fi
	# shellcheck disable=SC2145
	run_"$@"
}

run_usage() {
	run_usage_script_path=$(basename "${shelduck_run_script_path:-$0}")	
	printf '%s: %s\n' "$run_usage_script_path" "Usage: $run_usage_script_path SUBCOMMAND"
}
