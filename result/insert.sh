

shelduck import ../resource/copy.sh
shelduck import ../base.sh
shelduck import ./isset.sh


# fun: bobshell_result_insert ONEBASEDINDEX VALUE ...
bobshell_result_insert() {
	if ! [ 0 -lt "$1" ]; then
		bobshell_die "bobshell_result_insert: negative index: $1"
	fi
	if ! bobshell_result_isset; then
		bobshell_die "bobshell_result_insert: no result"
	fi
	if ! [ "$1" -le $(( bobshell_result_size + 1 )) ]; then
		bobshell_die "bobshell_result_insert: insert index $1 is out of array bounds ($bobshell_result_size)"
	fi

	_bobshell_result_insert__pos="$1"
	shift

	for _bobshell_result_insert__i in $(seq $(( _bobshell_result_insert__pos - 1 )) -1 1 ); do
		bobshell_resource_copy_var_to_var "bobshell_result_$_bobshell_result_insert__i" _bobshell_result_insert__buffer
		set -- "$_bobshell_result_insert__buffer" "$@"
	done
	for _bobshell_result_insert__i in $(seq $(( _bobshell_result_insert__pos )) "$bobshell_result_size" ); do
		bobshell_resource_copy_var_to_var "bobshell_result_$_bobshell_result_insert__i" _bobshell_result_insert__buffer
		set -- "$@" "$_bobshell_result_insert__buffer"
	done
	unset _bobshell_result_insert__i _bobshell_result_insert__buffer _bobshell_result_insert__pos

	bobshell_result_set "$@"
}
