


bobshell_str_repeat() {
	_bobshell_str_repeat__amount=$(( $1 - 1 ))
	shift
	_bobshell_str_repeat__pattern="$*"
	bobshell_result_set "$_bobshell_str_repeat__pattern"
	while [ "$_bobshell_str_repeat__amount" -gt 0 ]; do
		if [ $(( _bobshell_str_repeat__amount % 2 )) -eq 0 ]; then
			_bobshell_str_repeat__amount=$(( _bobshell_str_repeat__amount / 2 ))
			bobshell_result_1="$bobshell_result_1$bobshell_result_1"
		else
			_bobshell_str_repeat__amount=$(( _bobshell_str_repeat__amount - 1 ))
			bobshell_result_1="$bobshell_result_1$_bobshell_str_repeat__pattern"
		fi 
	done
	unset _bobshell_str_repeat__amount _bobshell_str_repeat__pattern
}