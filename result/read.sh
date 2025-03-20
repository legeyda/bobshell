
shelduck import ../base.sh

# fun: bobshell_result_get VAR ...
bobshell_result_read() {
	if   [ 0 = "$#" ]; then
		return
	fi

	if [ "$#" -gt "$bobshell_result_size" ]; then
		bobshell_die "not enough values in result"
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
	elif [ 6 = "$#" ]; then
		bobshell_resource_copy_var_to_var bobshell_result_1 "$1"
		bobshell_resource_copy_var_to_var bobshell_result_2 "$2"
		bobshell_resource_copy_var_to_var bobshell_result_3 "$3"
		bobshell_resource_copy_var_to_var bobshell_result_4 "$4"
		bobshell_resource_copy_var_to_var bobshell_result_5 "$5"
		bobshell_resource_copy_var_to_var bobshell_result_6 "$6"
	elif [ 7 = "$#" ]; then
		bobshell_resource_copy_var_to_var bobshell_result_1 "$1"
		bobshell_resource_copy_var_to_var bobshell_result_2 "$2"
		bobshell_resource_copy_var_to_var bobshell_result_3 "$3"
		bobshell_resource_copy_var_to_var bobshell_result_4 "$4"
		bobshell_resource_copy_var_to_var bobshell_result_5 "$5"
		bobshell_resource_copy_var_to_var bobshell_result_6 "$6"
		bobshell_resource_copy_var_to_var bobshell_result_7 "$7"
	elif [ 8 = "$#" ]; then
		bobshell_resource_copy_var_to_var bobshell_result_1 "$1"
		bobshell_resource_copy_var_to_var bobshell_result_2 "$2"
		bobshell_resource_copy_var_to_var bobshell_result_3 "$3"
		bobshell_resource_copy_var_to_var bobshell_result_4 "$4"
		bobshell_resource_copy_var_to_var bobshell_result_5 "$5"
		bobshell_resource_copy_var_to_var bobshell_result_6 "$6"
		bobshell_resource_copy_var_to_var bobshell_result_7 "$7"
		bobshell_resource_copy_var_to_var bobshell_result_8 "$8"
	elif [ 9 = "$#" ]; then
		bobshell_resource_copy_var_to_var bobshell_result_1 "$1"
		bobshell_resource_copy_var_to_var bobshell_result_2 "$2"
		bobshell_resource_copy_var_to_var bobshell_result_3 "$3"
		bobshell_resource_copy_var_to_var bobshell_result_4 "$4"
		bobshell_resource_copy_var_to_var bobshell_result_5 "$5"
		bobshell_resource_copy_var_to_var bobshell_result_6 "$6"
		bobshell_resource_copy_var_to_var bobshell_result_7 "$7"
		bobshell_resource_copy_var_to_var bobshell_result_8 "$8"
		bobshell_resource_copy_var_to_var bobshell_result_9 "$9"
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
