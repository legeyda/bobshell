
shelduck import ../result/set.sh
shelduck import ./split_v2.sh

bobshell_str_replace() {
	if [ -z "$2" ]; then
		bobshell_die 'bobshell_str_replace: empty needle'
	fi

	_bobshell_replace__rest="$1"
	_bobshell_replace__result=
	while [ -n "$_bobshell_replace__rest" ]; do
		bobshell_str_split_v2 "$_bobshell_replace__rest" "$2" 2
		if [ "$bobshell_result_size" -ge 2 ]; then
			_bobshell_replace__result="$_bobshell_replace__result$bobshell_result_1${3:-}"
			_bobshell_replace__rest="$bobshell_result_2"
		else
			_bobshell_replace__result="$_bobshell_replace__result$_bobshell_replace__rest"
			break
		fi
	done
	unset _bobshell_replace__rest
	bobshell_result_set "$_bobshell_replace__result"
	unset _bobshell_replace__result
}
