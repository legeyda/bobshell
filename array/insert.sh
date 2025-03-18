

shelduck import ../resource/copy.sh
shelduck import ./size.sh
shelduck import ./assert_isset.sh
shelduck import ../result/assert.sh



# fun: bobshell_array_insert ARRAYNAME ONEBASEDINDEX VALUE
bobshell_array_insert() {
	if ! [ 0 -lt "$2" ]; then
		bobshell_die "bobshell_array_insert: negative index: $2"
	fi
	bobshell_array_assert_isset "$1"
	bobshell_array_size "$1"
	bobshell_result_assert _bobshell_array_insert__size

	if ! [ "$2" -le "$_bobshell_array_insert__size" ]; then
		bobshell_die "bobshell_array_insert: index out of bounds ($2 >= $_bobshell_array_insert__size)"
	fi


	for _bobshell_array_insert__i in $(seq "$_bobshell_array_insert__size" -1 "$2"); do
		bobshell_resource_copy_var_to_var "$1_$_bobshell_array_insert__i" "$1_$(( _bobshell_array_insert__i + 1))"
	done
	unset _bobshell_array_insert__i
	bobshell_putvar "${1}_$2" "$3"

	_bobshell_array_insert__size=$(( _bobshell_array_insert__size + 1 ))
	bobshell_putvar "${1}_size" "$_bobshell_array_insert__size"
	unset _bobshell_array_insert__size
}
