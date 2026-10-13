

shelduck import ../base.sh
shelduck import ../result/set.sh
shelduck import ../str/match.sh
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
		else
			bobshell_str_match "$1" '*[!-A-Za-z0-9_/=\.]*'
			if [ true = "$bobshell_result_1" ]; then
				bobshell_str_replace "$1" "'" "'"'"'"'"'"'"'"
				_bobshell_str_quote__result="$_bobshell_str_quote__result$_bobshell_str_quote__separator'$bobshell_result_2'"
			else
				_bobshell_str_quote__result="$_bobshell_str_quote__result$_bobshell_str_quote__separator$1"
			fi
		fi
		_bobshell_str_quote__separator=' '
		shift
	done
	bobshell_result_set "$_bobshell_str_quote__result"
	unset _bobshell_str_quote__result
}
