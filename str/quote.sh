

shelduck import ../base.sh
shelduck import ../regex/match.sh
shelduck import ./replace.sh
shelduck import ./quote.sh


bobshell_str_quote() {
	_bobshell_str_quote__separator=
	_bobshell_str_quote__result=
	while bobshell_isset_1 "$@"; do
		if [ -z "$1" ]; then
			_bobshell_str_quote__result="$_bobshell_str_quote__result$_bobshell_str_quote__separator''"
		elif bobshell_regex_match "$1" '[-A-Za-z0-9_/=\.]\+'; then
			_bobshell_str_quote__result="$_bobshell_str_quote__result$_bobshell_str_quote__separator$1"
		else
			bobshell_str_replace "$1" "'" "'"'"'"'"'"'"'"
			_bobshell_str_quote__result="$_bobshell_str_quote__result$_bobshell_str_quote__separator'$bobshell_result_1'"
		fi
		_bobshell_str_quote__separator=' '
		shift
	done
	unset _bobshell_str_quote__separator
	bobshell_result_set "$_bobshell_str_quote__result"
	unset _bobshell_str_quote__result
}