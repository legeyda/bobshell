

shelduck import ./size.sh
shelduck import ./assert_isset.sh
shelduck import ../resource/copy.sh
shelduck import ../result/assert.sh
shelduck import ../result/set.sh

# fun: bobshell_array_read ARRAYNAME ONEBASEDINDEX
bobshell_array_read() {
	if ! [ 0 -lt "$2" ]; then
		bobshell_die "bobshell_array_read: wrong index $2 < 1"
	fi
	bobshell_array_assert_isset "$1"
	bobshell_array_size "$1"
	bobshell_result_assert _bobshell_array_read__size
	if ! [ "$2" -le "$_bobshell_array_read__size" ]; then
		bobshell_die "bobshell_array_read: wrong index $2 >= $_bobshell_array_read__size"
	fi
	unset _bobshell_array_read__size

	_bobshell_array_read__result=$(bobshell_getvar "$1_$2")
	bobshell_result_set true "$_bobshell_array_read__result"
	unset _bobshell_array_read__result
}
