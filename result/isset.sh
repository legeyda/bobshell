

shelduck import ../base.sh

# fun: bobshell_result_isset
bobshell_result_isset() {
	if ! bobshell_isset bobshell_result_size; then
		return 1
	fi
}
