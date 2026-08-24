

shelduck import ../base.sh
shelduck import ../string.sh
shelduck import ../result/set.sh
shelduck import ../result/check.sh
shelduck import ../result/add.sh
shelduck import ../var/set.sh
shelduck import ../var/increment.sh


# fun: bobshell_str_split STR [SEPARATOR=:] [MAX_PARTS=inf]
# use: bobshell_str_split '1.2.3.4' '.' 2
bobshell_str_split_v2() {
	set -- "$1" "${2:-:}" "${3:-inf}"
	bobshell_result_set "$1"
	while true; do

		# check max number of parts
		if [ inf != "$3" ] && [ infinity != "$3" ] && [ "$bobshell_result_size" -ge "$3" ]; then
			break
		fi

		# do the split
		set -- "$1" "$2" "$3" "${1#*"$2"}"
		if [ "$1" = "$4" ]; then
			break
		fi
			

		# keep invariant for next iteration
		set -- "$4" "$2" "$3" "${1%%"$2"*}"
		bobshell_var_set "bobshell_result_$(( bobshell_result_size ))" "$4"
		bobshell_result_add "$1"
	done

#		bobshell_result_add "$1"
}