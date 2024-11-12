




bobshell_entry_point() {
	#1set -eu

	bobshell_script_path=$(realpath "$0")
	bobshell_main_pid=$$
	bobshell_script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)
	main "$@"
}


# invoke bobshell_entry_point if script is actually run, not sourced (see https://stackoverflow.com/a/28776166)
if [ -n "${ZSH_VERSION:-}" ]; then 
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