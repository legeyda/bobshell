
shelduck import ../result/set.sh

# fun: bobshell_str_match STR PATTERN
# res: true
# res: false
bobshell_str_match() {
	_bobshell_str_match="$1"
	shift
	bobshell_result_set_1 false
	while [ $# -gt 0 ]; do
		case "$_bobshell_str_match" in
			($1)
				bobshell_result_set_1 true
				break
				;;
		esac
		shift
	done
}
