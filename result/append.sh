
shelduck import ../base.sh
shelduck import ../var/set.sh
shelduck import ../var/increment.sh

# fun: bobshell_result_append VALUE [MOREVALUES ...]
# todo append vs add
bobshell_result_append() {
	while [ "$#" -gt 0 ]; do
		bobshell_var_increment bobshell_result_size
		bobshell_var_set "bobshell_result_$bobshell_result_size" "$1"
		shift
	done
}
