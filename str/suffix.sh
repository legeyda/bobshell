
shelduck import ../result/set.sh

# fun: bobshell_str_prefix STR PREFIX
# res: true RESTOFLINE
# res: false
bobshell_str_suffix() {
	if [ -z "$2" ]; then
		bobshell_result_set true "$1"
		return
	fi
	set -- "$1" "$2" "${1%"$2"}"
	if [ "$1" = "$3" ]; then
		bobshell_result_set false
	else
		bobshell_result_set true "$3"
	fi
}
