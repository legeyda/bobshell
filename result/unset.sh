
bobshell_result_unset() {
	if   [ 0 = "${bobshell_result_size:-0}" ]; then
		unset bobshell_result_size
	elif [ 1 = "$bobshell_result_size" ]; then
		unset bobshell_result_size bobshell_result_1
	elif [ 2 = "$bobshell_result_size" ]; then
		unset bobshell_result_size bobshell_result_1 bobshell_result_2
	elif [ 3 = "$bobshell_result_size" ]; then
		unset bobshell_result_size bobshell_result_1 bobshell_result_2 bobshell_result_3
	else
		while [ 0 -lt "$bobshell_result_size" ]; do
			unset "bobshell_result_$bobshell_result_size"
			bobshell_result_size=$(( bobshell_result_size - 1 ))
		done
		unset bobshell_result_size
	fi	
}
