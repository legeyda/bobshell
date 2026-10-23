

shelduck import ../base.sh
shelduck import ../string.sh
shelduck import ../result/set.sh
shelduck import ../result/check.sh
shelduck import ../result/add.sh
shelduck import ../var/set.sh
shelduck import ../var/increment.sh


# fun: bobshell_str_split_v3 STR SEPARATOR
# use: bobshell_str_split_v3 key=value =
# res: true part1 part2
# res: false
bobshell_str_split_v3() {
	set -- "$1" "$2" "${1#*"$2"}"
	if [ "$1" = "$3" ]; then
		bobshell_result_set_1 false
	else
		bobshell_result_set_3 true "${1%%"$2"*}" "$3"
	fi
}
