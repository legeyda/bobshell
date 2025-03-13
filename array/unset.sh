

shelduck import ./size.sh

# fun: bobshell_array_unset ARRAYNAME
bobshell_array_unset() {
	if ! bobshell_array_isset "$1"; then
		return
	fi
	_bobshell_array_unset__size=$(bobshell_array_size "$1")
	for _bobshell_array_unset__i in $(seq "$_bobshell_array_unset__size"); do
		unset "${1}_$_bobshell_array_unset__i"
	done
	unset "${1}_size"
}
