

shelduck import ./size.sh

# fun: bobshell_array_unset ARRAYNAME
bobshell_array_unset() {
	if bobshell_isset "$1_size"; then
		_bobshell_array_unset__size=$(bobshell_getvar "$1_size")
		for _bobshell_array_unset__i in $(seq "$_bobshell_array_unset__size"); do
			unset "${1}_$_bobshell_array_unset__i"
		done
		unset "$1_size"
		unset _bobshell_array_unset__size
	else
		_bobshell_array_unset__i=1
	fi

	while bobshell_isset "${1}_$_bobshell_array_unset__i"; do
		unset "${1}_$_bobshell_array_unset__i"
		_bobshell_array_unset__i=$(( 1 +_bobshell_array_unset__i ))
	done
	unset _bobshell_array_unset__i
}
