
bobshell_result_unset() {


	if [ "${bobshell_result_size:-0}" -gt 0 ]; then
		unset bobshell_result_1
		_bobshell_result_unset__i=2
		while [ "$_bobshell_result_unset__i" -lt "$bobshell_result_size" ]; do
			unset bobshell_result_$_bobshell_result_unset__i
			_bobshell_result_unset__i=$(( _bobshell_result_unset__i + 1 ))
		done
	else
		_bobshell_result_unset__i=1	
	fi
	unset bobshell_result_size

	while bobshell_isset bobshell_result_"$_bobshell_result_unset__i"; do
		unset bobshell_result_"$_bobshell_result_unset__i"
		_bobshell_result_unset__i=$(( _bobshell_result_unset__i + 1 ))
	done
	unset _bobshell_result_unset__i
}
