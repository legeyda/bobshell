
shelduck import ../base.sh
shelduck import ./size.sh
shelduck import ./assert_isset.sh
shelduck import ../result/assert.sh

# fun: bobshell_array_call ARRAYNAME COMMAND [ARGS...]
bobshell_array_foreach() {
	bobshell_array_assert_isset "$1"

	bobshell_array_size "$1"
	bobshell_result_assert _bobshell_array_foreach__size

	if [ 0 = "$_bobshell_array_foreach__size" ]; then
		unset _bobshell_array_foreach__size
		return
	fi
	_bobshell_array_foreach__name="$1"
	shift
	for _bobshell_array_foreach__i in $(seq "$_bobshell_array_foreach__size"); do
		_bobshell_array_foreach__item=$(bobshell_getvar "${_bobshell_array_foreach__name}_$_bobshell_array_foreach__i")
		"$@" "$_bobshell_array_foreach__item"
	done
	unset _bobshell_array_foreach__name _bobshell_array_foreach__size _bobshell_array_foreach__i _bobshell_array_foreach__item
}
