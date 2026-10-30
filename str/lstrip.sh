


bobshell_str_lstrip() {
	bobshell_result_size=2
	bobshell_result_1=
	bobshell_result_2="$1"
	set -- "${2:-[[:space:]]}"
	while case "$bobshell_result_2" in ($1*) true ;; (*) false ;; esac; do
		bobshell_result_1="${bobshell_result_1}${bobshell_result_2%"${bobshell_result_2#?}"}"
		bobshell_result_2="${bobshell_result_2#?}"
	done
}
