
shelduck import ../base.sh

# fun: bobshell_result_call COMMAND [ARGS...]
# todo
bobshell_result_foreach() {
	_bobshell_result_foreach__i=1
	while [ "$_bobshell_result_foreach__i" -le "$bobshell_result_size" ]; do
		eval '_bobshell_result_foreach__value="$bobshell_result_'"$_bobshell_result_foreach__i"'"'
		"$@" "$_bobshell_result_foreach__value"
		_bobshell_result_foreach__i=$(( _bobshell_result_foreach__i + 1 ))
	done
	unset _bobshell_result_foreach__i _bobshell_result_foreach__value
}
