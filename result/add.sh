
shelduck import ../base.sh
shelduck import ../var/set.sh

# fun: bobshell_result_add VALUE ...
bobshell_result_add() {
	while [ "$#" -gt 0 ]; do
		bobshell_result_size=$(( bobshell_result_size + 1 ))
		bobshell_var_set "bobshell_result_$bobshell_result_size" "$1"
		shift
	done
}
