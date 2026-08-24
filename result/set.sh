

# fun: bobshell_result_set [ITEMS...]
bobshell_result_set() {
	if [ $# -gt 0 ]; then
		bobshell_result_size=1
		bobshell_result_1="$1"
		while [ $# -gt 1 ]; do
			shift
			bobshell_result_size=$(( bobshell_result_size + 1 ))
			eval 'bobshell_result_'"$bobshell_result_size"'="$1"'
		done
	else
		bobshell_result_size=0
	fi

	_bobshell_result_set__i=$(( bobshell_result_size + 1 ))
	while bobshell_isset bobshell_result_"$_bobshell_result_set__i"; do
		unset bobshell_result_"$_bobshell_result_set__i"
		_bobshell_result_set__i=$(( _bobshell_result_set__i + 1 ))
	done

}
