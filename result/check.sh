
shelduck import ./read.sh

bobshell_result_check() {
	if [ '0' = "${bobshell_result_size:-0}" ]; then
		bobshell_die "bobshell_result_check: no result"
	fi
	case "$bobshell_result_1" in
		(true)  ;;
		(false) return 1 ;;
		(*) bobshell_die "bobshell_result_check: error parsing result as boolean: $bobshell_result_1"
	esac
	bobshell_result_read - "$@"
}
