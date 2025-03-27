
shelduck import ../result/unset.sh


# fun: bobshell_result_set [ITEMS...]
bobshell_result_set() {
	if [ "${bobshell_result_size:-0}" -lt 4 ] && [ "$#" -lt 4 ]; then
		if   [ 0 = "$#" ]; then
			bobshell_result_size=0
			unset bobshell_result_1 bobshell_result_2 bobshell_result_3
			return
		elif [ 1 = "$#" ]; then
			bobshell_result_size=1
			bobshell_result_1="$1"
			unset bobshell_result_2 bobshell_result_3
			return
		elif [ 2 = "$#" ]; then
			bobshell_result_size=2
			bobshell_result_1="$1"
			bobshell_result_2="$2"
			unset bobshell_result_3
			return
		elif [ 3 = "$#" ]; then
			bobshell_result_size=3
			bobshell_result_1="$1"
			bobshell_result_2="$2"
			bobshell_result_3="$3"
			return
		fi
	fi

	bobshell_result_unset
	bobshell_result_size=0
	while bobshell_isset_1 "$@"; do
		bobshell_result_size=$(( 1 + bobshell_result_size ))
		bobshell_putvar "bobshell_result_$bobshell_result_size" "$1"
		shift
	done
}
