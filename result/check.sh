
shelduck import ./read.sh
shelduck import ../misc/log.sh

bobshell_result_check() {
	if [ '0' = "${bobshell_result_size:-0}" ]; then
		bobshell_die "bobshell_result_check: no result"
	fi
	case "$bobshell_result_1" in
		(true)  ;;
		(false) return 1 ;;
		(*) bobshell_die "bobshell_result_check: error parsing result as boolean: $bobshell_result_1"
	esac

	if ! [ "$#" -lt "${bobshell_result_size:-0}" ]; then
		return 1
	fi

	for _bobshell_result_check__i in $(seq 2 $(( $# + 1 )) ); do
	    if [ "$1" ] && [ - != "$1" ]; then
		    bobshell_resource_copy_var_to_var "bobshell_result_$_bobshell_result_check__i" "$1"
        fi
		shift
	done
	unset _bobshell_result_check__i
}
