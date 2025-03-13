

shelduck import ../base.sh

# fun: bobshell_array_set ARRAYNAME [ITEMS...]
bobshell_array_set() {
	_bobshell_array_set__name="$1"
	_bobshell_array_set__i=0
	while bobshell_isset_2 "$@"; do
		_bobshell_array_set__i=$(( _bobshell_array_set__i + 1 ))
		bobshell_putvar "${_bobshell_array_set__name}_$_bobshell_array_set__i" "$2"
		shift
	done
	bobshell_putvar "${_bobshell_array_set__name}_size" "$_bobshell_array_set__i"
	unset _bobshell_array_set__i _bobshell_array_set__name
}
