
shelduck import ../resource/copy.sh
shelduck import ./assert_isset.sh
shelduck import ./size.sh
shelduck import ../result/assert.sh

# fun: bobshell_array_remove ARRAYNAME ONEBASEDINDEX
bobshell_array_remove() {
	if ! [ 0 -lt "$2" ]; then
		bobshell_die "bobshell_array_remove: negative index"
	fi
	bobshell_array_assert_isset "$1"
	bobshell_array_size "$1"
	bobshell_result_assert _bobshell_array_remove__size
	if ! [ 0 -lt "$_bobshell_array_remove__size" ]; then
		bobshell_die "bobshell_array_remove: empty array"
	fi
	if ! [ "$2" -le "$_bobshell_array_remove__size" ]; then
		bobshell_die "bobshell_array_remove: index out of bound $_bobshell_array_remove__size"
	fi

	if [ "$2" -lt "$_bobshell_array_remove__size" ]; then
		for _bobshell_array_remove__i in $(seq "$2" $(( _bobshell_array_remove__size - 1)) ); do
			bobshell_resource_copy_var_to_var "$1_$(( _bobshell_array_remove__i + 1))" "$1_$_bobshell_array_remove__i"
		done
	fi
	unset "$1_$_bobshell_array_remove__size"


	_bobshell_array_remove__size=$(( _bobshell_array_remove__size - 1 ))
	bobshell_putvar "$1_size" "$_bobshell_array_remove__size"
	unset _bobshell_array_remove__size
}
