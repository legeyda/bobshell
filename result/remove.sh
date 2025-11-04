

shelduck import ../resource/copy.sh
shelduck import ../base.sh
shelduck import ./isset.sh


# fun: bobshell_result_remove ONEBASEDINDEX [AMOUNT=1]
bobshell_result_remove() {

	if ! bobshell_result_isset; then
		bobshell_die "bobshell_result_remove: no result"
	fi

	_bobshell_result_remove__start=$(( $1 ))
	if ! [ 0 -lt "$_bobshell_result_remove__start" ]; then
		bobshell_die "bobshell_result_remove: start position out of bounds: $1"
	fi

	_bobshell_result_remove__end=$(( $1 + ${2:-1} - 1 ))
	if ! [ $(( _bobshell_result_remove__end )) -le $(( bobshell_result_size )) ]; then
		bobshell_die "bobshell_result_remove: end position ($1 + ${2:-1} - 1 = $_bobshell_result_remove__end) out of bounds ($bobshell_result_size)"
	fi

	set --
	for _bobshell_result_remove__i in $(seq $(( _bobshell_result_remove__start - 1)) ); do
		bobshell_resource_copy_var_to_var "bobshell_result_$_bobshell_result_remove__i" _bobshell_result_remove__buffer
		set -- "$@" "$_bobshell_result_remove__buffer"
	done
	for _bobshell_result_remove__i in $(seq $(( _bobshell_result_remove__end + 1 )) bobshell_result_size ); do
		bobshell_resource_copy_var_to_var "bobshell_result_$_bobshell_result_remove__i" _bobshell_result_remove__buffer
		set -- "$@" "$_bobshell_result_remove__buffer"
	done
	unset _bobshell_result_remove__i _bobshell_result_remove__buffer _bobshell_result_remove__start _bobshell_result_remove__end

	bobshell_result_set "$@"
}
