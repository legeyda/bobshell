
shelduck import ../result/set.sh

# fun: bobshell_split_first STR SUBSTR
bobshell_str_split_first() {
	_bobshell_tmp=${1#*"$2"}
	if [ "$1" = "$_bobshell_tmp" ]; then
		bobshell_result_set false
	else
		bobshell_result_set true "${1%%"$2"*}" "$_bobshell_tmp"
	fi
}