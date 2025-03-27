
shelduck import ../base.sh
shelduck import ../resource/copy.sh

# fun: bobshell_result_get VAR ...
bobshell_result_read() {

	if [ "$#" -gt "${bobshell_result_size:-0}" ]; then
		return 1
	fi

	if   [ 1 = "$#" ]; then
		bobshell_resource_copy_var_to_var bobshell_result_1 "$1"
	elif [ 2 = "$#" ]; then
		bobshell_resource_copy_var_to_var bobshell_result_1 "$1"
		bobshell_resource_copy_var_to_var bobshell_result_2 "$2"
	elif [ 3 = "$#" ]; then
		bobshell_resource_copy_var_to_var bobshell_result_1 "$1"
		bobshell_resource_copy_var_to_var bobshell_result_2 "$2"
		bobshell_resource_copy_var_to_var bobshell_result_3 "$3"
	elif [ 4 = "$#" ]; then
		bobshell_resource_copy_var_to_var bobshell_result_1 "$1"
		bobshell_resource_copy_var_to_var bobshell_result_2 "$2"
		bobshell_resource_copy_var_to_var bobshell_result_3 "$3"
		bobshell_resource_copy_var_to_var bobshell_result_4 "$4"
	elif [ 5 = "$#" ]; then
		bobshell_resource_copy_var_to_var bobshell_result_1 "$1"
		bobshell_resource_copy_var_to_var bobshell_result_2 "$2"
		bobshell_resource_copy_var_to_var bobshell_result_3 "$3"
		bobshell_resource_copy_var_to_var bobshell_result_4 "$4"
		bobshell_resource_copy_var_to_var bobshell_result_5 "$5"
	else
		for _bobshell_result_read__i in $(seq "$#"); do
			bobshell_resource_copy_var_to_var "bobshell_result_$_bobshell_result_read__i" "$1"
			shift
			if ! bobshell_isset_1 "$@"; then
				break
			fi
		done
		unset _bobshell_result_read__i
	fi

}
