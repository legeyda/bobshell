
shelduck import ../result/set.sh

# fun: bobshell_str_match STR PATTERN
# res: true
# res: false
bobshell_str_match() {
	case "$1" in
		($2) bobshell_result_set_1 true  ;;
		(*)  bobshell_result_set_1 false ;;
	esac
}
