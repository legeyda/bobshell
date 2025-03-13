
shelduck import ../resource/copy.sh
shelduck import ./assert_isset.sh

# fun: bobshell_array_call ARRAYNAME [COMMAND [ARGS...]]
bobshell_array_call() {
	bobshell_array_assert_isset "$1"
	_bobshell_array_call__size=$(bobshell_array_size "$1")
	for _bobshell_array_call__i in $(seq "$_bobshell_array_call__size"); do
		_bobshell_array_call__item=$(bobshell_getvar "$1_$_bobshell_array_call__i")
		set -- "$@" "$_bobshell_array_call__item"
		unset _bobshell_array_call__item
	done
	if ! bobshell_isset_2 "$@"; then
		bobshell_die "bobshell_array_call: empty arguments"
	fi
	shift
	"$@"
}
