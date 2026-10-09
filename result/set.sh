

# fun: bobshell_result_set [ITEMS...]
bobshell_result_set() {
	if [ $# -le 9 ]; then
		"bobshell_result_set_$#" "$@"
		return
	fi

	bobshell_result_set_generic "$@"
}

bobshell_result_set_generic() {
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
	unset _bobshell_result_set__i
}

bobshell_result_set_init() {
	for i in $(seq 0 9); do
		x='
bobshell_result_set_'"$i"'() {
	bobshell_result_size='"$i"'
'
		for j in $(seq 1 $i); do
			x="$x"'	bobshell_result_'"$j"'="$'"$j"'"
'
		done
		for j in $(seq $(( i + 1 )) 9); do
			x="$x"'	unset bobshell_result_'"$j"'
'
		done
		x="$x}"'
'
		eval "$x"
	done
}

bobshell_result_set_init
