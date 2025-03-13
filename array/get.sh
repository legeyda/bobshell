

shelduck import ./size.sh
shelduck import ./assert_isset.sh

shelduck import ../resource/copy.sh
# fun: bobshell_array_get ARRAYNAME ONEBASEDINDEX VAR
bobshell_array_get() {
	if ! [ 0 -lt "$2" ]; then
		bobshell_die "bobshell_array_get: wrong index $2 < 1"
	fi
	bobshell_array_assert_isset "$1"
	_bobshell_array_get__size=$(bobshell_array_size "$1")
	if ! [ "$2" -le "$_bobshell_array_get__size" ]; then
		bobshell_die "bobshell_array_get: wrong index $2 >= $_bobshell_array_get__size"
	fi
	unset _bobshell_array_get__size

	if bobshell_isset_3 "$@"; then
		bobshell_resource_copy_var_to_var "$1_$2" "$3"
	else
		bobshell_getvar "$1_$2"
	fi
}
