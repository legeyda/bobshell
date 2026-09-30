
shelduck import ../base.sh
shelduck import ./isset.sh

# fun: bobshell_result_call COMMAND [ARGS...]
# todo
bobshell_result_foreach() {
    if ! bobshell_result_isset; then
        bobshell_die bobshell_result_foreach: no result
    fi

	_bobshell_result_foreach__i=1
	while ! [ "$_bobshell_result_foreach__i" -gt "$bobshell_result_size" ]; do
		eval '_bobshell_result_foreach__value="$bobshell_result_'"$_bobshell_result_foreach__i"'"'
		"$@" "$_bobshell_result_foreach__value"
		_bobshell_result_foreach__i=$(( _bobshell_result_foreach__i + 1 ))
	done
	unset _bobshell_result_foreach__i _bobshell_result_foreach__value
}
