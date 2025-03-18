

shelduck import ../base.sh
shelduck import ./assert_isset.sh
shelduck import ./size.sh
shelduck import ../result/assert.sh


# fun: bobshell_array_write ARRAYNAME ONEBASEDINDEX VALUE
bobshell_array_write() {
	if ! [ 0 -lt "$2" ]; then
		bobshell_die "bobshell_array_write: wrong index $2 < 1"
	fi
	bobshell_array_assert_isset "$1"
	bobshell_array_size "$1"
	bobshell_result_assert _bobshell_array_write__size
	if ! [ "$2" -le "$_bobshell_array_write__size" ]; then
		bobshell_die "bobshell_array_write: wrong index $2 >= $_bobshell_array_write__size"
	fi
	unset _bobshell_array_write__size
	bobshell_putvar "$1_$2" "$3"
}
