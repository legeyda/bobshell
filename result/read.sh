
shelduck import ../base.sh

# fun: bobshell_result_get VAR ...
bobshell_result_read() {
	if bobshell_isset_1 "$1"; then
		if ! [ "$#" -le "${bobshell_result_size:-0}" ]; then
			bobshell_die "bobshell_result_read: no result"
		fi

		for _bobshell_result_get__i in $(seq "$bobshell_result_size"); do
			if [ "$1" != - ]; then
				bobshell_resource_copy_var_to_var "bobshell_result_$_bobshell_result_get__i" "$1"
			fi			
			shift
			if ! bobshell_isset_1 "$@"; then
				break
			fi
		done
		unset _bobshell_result_get__i _bobshell_result_get__item
	fi
}
