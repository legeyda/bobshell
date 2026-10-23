


bobshell_str_strip() {
	bobshell_result_size=1
	bobshell_result_1="$1"
	set -- "${2:-[[:space:]]}"
	while case "$bobshell_result_1" in ($1*) true ;; (*) false ;; esac; do
		bobshell_result_1="${bobshell_result_1#?}"
	done
	while case "$bobshell_result_1" in (*$1) true ;; (*) false ;; esac; do
		bobshell_result_1="${bobshell_result_1%?}"
	done
}
