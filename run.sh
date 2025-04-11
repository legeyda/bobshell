
shelduck import base.sh
shelduck import string.sh
shelduck import crypto.sh
shelduck import require.sh
shelduck import util.sh
shelduck import app.sh

main() {
	if [ -z "${1:-}" ]; then
		run_usage >&2
		bobshell_die
	fi
	
	on_start
	bobshell_handle_subcommand "$@"
}

on_start() {
	true # do nothing
}

bobshell_handle_subcommand() {
	if [ -z "${1:-}" ]; then
		return
	fi
	bobshell_handle_subcommand_target=$(bobshell_replace "$1" - _)
	shift
	"run_$bobshell_handle_subcommand_target" "$@"
}

run_usage() {
	run_usage_script_path=$(basename "${shelduck_run_script_path:-$0}")	
	printf '%s: %s\n' "$run_usage_script_path" "Usage: $run_usage_script_path SUBCOMMAND"
}

# fun: run_glance FILE
run_glance() {
	bobshell_require_file_exists "${1:-}"
	bobshell_ensure_password
	bobshell_decrypt var:bobshell_secret_password "file:$1" stdout:
}

# fun: run_encrypt FILE
run_encrypt() {
	bobshell_require_file_exists "${1:-}"
	bobshell_ensure_password
	bobshell_encrypt var:bobshell_secret_password "file:$1" "file:$1"
}

# fun: run_decrypt FILE
run_decrypt() {
	bobshell_require_file_exists "${1:-}"
	bobshell_ensure_password
	bobshell_decrypt var:bobshell_secret_password "file:$1" "file:$1"
}

bobshell_ensure_password() {
	if bobshell_isset bobshell_secret_password; then
		return
	fi


	bobshell_ensure_password_upper=$(bobshell_upper_case "${bobshell_app_name}")
	if bobshell_isset "${bobshell_ensure_password_upper}_SECRET_PASSWORD"; then
		bobshell_secret_password=$(bobshell_getvar "${bobshell_ensure_password_upper}_SECRET_PASSWORD")
		return
	fi


	bobshell_ensure_password_tty="$(tty)"
	bobshell_require_not_empty "$bobshell_ensure_password_tty" 'terminal not found, not interactive shell?'
	printf %s "Password:" > "$(tty)"
	bobshell_read_secret bobshell_secret_password

}