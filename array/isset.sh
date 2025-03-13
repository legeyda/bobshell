

shelduck import ../base.sh

# fun: bobshell_array_set ARRAYNAME
bobshell_array_isset() {
	if ! bobshell_isset "${1}_size"; then
		return 1
	fi
}
