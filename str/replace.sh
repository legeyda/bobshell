
shelduck import ../string.sh
shelduck import ../result/set.sh

bobshell_replace() {
  	# https://freebsdfrau.gitbook.io/serious-shell-programming/string-functions/replace_substringall
	bobshell_replace_str="$1"
	bobshell_replace__result=
	while bobshell_split_first "$bobshell_replace_str" "$2" bobshell_replace_left bobshell_replace_str; do
		bobshell_replace__result="$bobshell_replace__result$bobshell_replace_left$3"
	done
	bobshell_replace__result="$bobshell_replace__result$bobshell_replace_str"
	bobshell_result_set "$bobshell_replace__result"
	unset bobshell_replace_str bobshell_replace__result bobshell_replace_left 
}