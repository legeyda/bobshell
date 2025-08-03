
shelduck import ./read.sh


bobshell_result_assert() {
	if [ '0' = "${bobshell_result_size:-0}" ]; then
		bobshell_die "bobshell_result_assert: no result"
	fi
	case "$bobshell_result_1" in
		(true)  ;;
		(false)
			if [ 1 -lt "$bobshell_result_size" ]; then
				bobshell_die "bobshell_result_assert: $*"
			else
				bobshell_die "bobshell_result_assert: bobshell_result_1 expected to be true"
			fi
			;;
		(*)     bobshell_die "bobshell_result_assert: error parsing result as boolean: $bobshell_result_1"
	esac
	bobshell_result_read _bobshell_result_assert__unused "$@"
	unset _bobshell_result_assert__unused
}
