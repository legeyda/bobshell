

shelduck import ../var/get.sh

# bobshell_map_get mapname key 
bobshell_map_get() {
	_bobshell_map_get__hash=$(printf %s "$2" | sed 's/[^A-Za-z_0-9]/_/g') # todo optimize somehow

	bobshell_var_get "${1}_bag_$_bobshell_map_get__hash"
	if ! bobshell_result_check _bobshell_map_get__bag; then
		unset _bobshell_map_get__hash
		bobshell_result_set false
		return
	fi

	for _bobshell_map_get__ref in $_bobshell_map_get__bag; do
		bobshell_var_get "${1}_key_$_bobshell_map_get__ref"
		bobshell_result_check _bobshell_map_get__key

		if [ "$2" = "$_bobshell_map_get__key" ]; then
			unset _bobshell_map_get__hash _bobshell_map_get__bag

			bobshell_var_get "${1}_val_$_bobshell_map_get__ref"
			unset _bobshell_map_get__ref
			bobshell_result_check _bobshell_map_get__value

			bobshell_result_set true "$_bobshell_map_get__value"
			unset _bobshell_map_get__value
			return
		fi
		unset _bobshell_map_get__key
	done

	unset _bobshell_map_get__hash _bobshell_map_get__bag
	bobshell_result_set false
}