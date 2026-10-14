
shelduck import ../base.sh
shelduck import ../resource/copy.sh
shelduck import ../misc/log.sh

# fun: bobshell_result_read VAR ...
bobshell_result_read() {
	if ! [ "$#" -le "${bobshell_result_size:-0}" ]; then
		bobshell_log_error 'bobshell_result_read: number of resulting variables ('"$#"') is greater than number of available values ('"${bobshell_result_size:-undefined}"')'
		return 1
	fi

	for _bobshell_result_read__i in $(seq "$#"); do
	    if [ "$1" ] && [ - != "$1" ]; then
		    bobshell_resource_copy_var_to_var "bobshell_result_$_bobshell_result_read__i" "$1"
        fi
		shift
	done
	unset _bobshell_result_read__i
}
