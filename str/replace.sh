
shelduck import ../string.sh
shelduck import ../result/set.sh

bobshell_str_replace() {
  	# https://freebsdfrau.gitbook.io/serious-shell-programming/string-functions/replace_substringall
	_bobshell_replace__rest="$1"
	_bobshell_replace__result=
	while bobshell_split_first "$_bobshell_replace__rest" "$2" _bobshell_replace_left _bobshell_replace__rest; do
		_bobshell_replace__result="$_bobshell_replace__result$_bobshell_replace_left$3"
	done
	_bobshell_replace__result="$_bobshell_replace__result$_bobshell_replace__rest"
	bobshell_result_set "$_bobshell_replace__result"
	unset _bobshell_replace__rest _bobshell_replace__result _bobshell_replace_left 
}