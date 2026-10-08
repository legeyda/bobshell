

shelduck import ../base.sh
shelduck import ../result/set.sh
shelduck import ../regex/match.sh
shelduck import ./replace.sh


bobshell_str_quote() {
	_bobshell_str_quote__result=
	_bobshell_str_quote__separator=
	while [ $# -gt 0 ]; do
		if [ -z "$1" ]; then
			_bobshell_str_quote__result="$_bobshell_str_quote__result$_bobshell_str_quote__separator''"
		elif bobshell_contains "$1" "$bobshell_newline"; then
			bobshell_str_replace "$1" "'" "'"'"'"'"'"'"'"
			_bobshell_str_quote__result="$_bobshell_str_quote__result$_bobshell_str_quote__separator'$bobshell_result_2'"
		elif bobshell_regex_match "$1" '^[-A-Za-z0-9_/=\.]\+$'; then
			_bobshell_str_quote__result="$_bobshell_str_quote__result$_bobshell_str_quote__separator$1"
		else
			bobshell_str_replace "$1" "'" "'"'"'"'"'"'"'"
			_bobshell_str_quote__result="$_bobshell_str_quote__result$_bobshell_str_quote__separator'$bobshell_result_2'"
		fi

		_bobshell_str_quote__separator=' '
		shift
	done
	bobshell_result_set "$_bobshell_str_quote__result"
	unset _bobshell_str_quote__result
}
