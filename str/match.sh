
shelduck import ../result/set.sh

# fun: bobshell_str_match STR PATTERN
# res: true
# res: false
bobshell_str_match() {
	if [ -z "$2" ]; then
		if [ -z "$1" ]; then
			bobshell_result_set_1 true
		else
			bobshell_result_set_1 false
		fi
		return
	fi
	eval 'case "$1" in
	('"$2"') bobshell_result_set_1 true  ;;
	(*)    bobshell_result_set_1 false ;;
esac'
}
