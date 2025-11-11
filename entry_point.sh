




bobshell_entry_point() {
	set -eu


	bobshell_main_pid=$$
	bobshell_script_path="${shelduck_run_script_path:-$0}"
	bobshell_script_name=$(basename "$bobshell_script_path")
	bobshell_script_dir=$(dirname "$bobshell_script_path")
	bobshell_script_dir=$(CDPATH= cd -- "$bobshell_script_dir" && pwd -P)

	if [ -n "${shelduck_run_args:-}" ]; then
		eval "main $shelduck_run_args"
	else
		main "$@"
	fi
}


# invoke bobshell_entry_point if script is actually run, not sourced (see https://stackoverflow.com/a/28776166)
if [ -n "${shelduck_run_script_path:-}" ]; then
	bobshell_entry_point "$@"
elif [ -n "${ZSH_VERSION:-}" ]; then 
	case $ZSH_EVAL_CONTEXT in *:file) ;; *) bobshell_entry_point "$@";; esac
elif [ -n "${KSH_VERSION:-}" ]; then
	# shellcheck disable=SC2296 
	# we have explicitly checked for ksh
	[ "$(cd -- "$(dirname -- "$0")" && pwd -P)/$(basename -- "$0")" != "$(cd -- "$(dirname -- "${.sh.file}")" && pwd -P)/$(basename -- "${.sh.file}")" ] || bobshell_entry_point "$@"
elif [ -n "${BASH_VERSION:-}" ]; then
	(return 0 2>/dev/null) || bobshell_entry_point "$@"
else # All other shells: examine $0 for known shell binary filenames.
	# Detects `sh` and `dash`; add additional shell filenames as needed.
	case ${0##*/} in sh|-sh|dash|-dash) ;; *) bobshell_entry_point "$@" ;; esac
fi