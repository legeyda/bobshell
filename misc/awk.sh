
shelduck import ../base.sh
shelduck import ../resource/copy.sh
shelduck import ../locator/is_stdin.sh
shelduck import ../locator/is_stdout.sh
shelduck import ../base.sh
shelduck import ../redirect/io.sh
shelduck import ../redirect/input.sh

# fun: bobshell_awk INPUT OUTPUT AWKARGS...
bobshell_awk() {
	bobshell_isset_3 "$@" || bobshell_die 'bobshell_awk: 3 arguments required'
	
	bobshell_awk__input="$1"
	shift

	bobshell_awk__output="$1"
	shift
	
	if bobshell_locator_is_file "$bobshell_awk__input" bobshell_awk__input_file; then
		bobshell_redirect_output "$bobshell_awk__output" awk "$@" "$bobshell_awk__input_file"
		unset bobshell_awk__input_file
	else
		bobshell_redirect_io "$bobshell_awk__input" "$bobshell_awk__output" awk "$@"
		unset bobshell_awk__input bobshell_awk__output
	fi
}
