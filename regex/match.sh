


bobshell_regex_match() {
	_bobshell_regex_match=$(expr "$1" : "$2")
	if [ "$_bobshell_regex_match" = "${#1}" ]; then
		unset _bobshell_regex_match
		return
	else
		unset _bobshell_regex_match
		return 1
	fi
}