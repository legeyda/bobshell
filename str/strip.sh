


shelduck import ../result/set.sh

bobshell_str_strip() {
	bobshell_result_size=1
	bobshell_result_1="$*"
	while case "$bobshell_result_1" in ([[:space:]]*) true ;; (*) false ;; esac; do
		bobshell_result_1="${bobshell_result_1#?}"
	done
	while case "$bobshell_result_1" in (*[[:space:]]) true ;; (*) false ;; esac; do
		bobshell_result_1="${bobshell_result_1%?}"
	done
}
