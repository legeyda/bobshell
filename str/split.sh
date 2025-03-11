

shelduck import ../base.sh
shelduck import ../string.sh
shelduck import ../result/ok.sh
shelduck import ../result/check.sh


# fun: bobshell_str_split STR SEPARATOR COMMAND [ARGS...]
# use: bobshell_str_split '1.2.3.4' '.' printf 'component %s, '
bobshell_str_split() {
	_bobshell_str_split__rest="$1"
	_bobshell_str_split__separator="$2"
	shift 2
	while bobshell_split_first "$_bobshell_str_split__rest" "$_bobshell_str_split__separator" _bobshell_str_split__part _bobshell_str_split__rest; do
		bobshell_result_ok
		"$@" "$_bobshell_str_split__part"
		if ! bobshell_result_check; then
			unset _bobshell_str_split__rest _bobshell_str_split__separator
			bobshell_result_ok
			return
		fi
	done
	"$@" "$_bobshell_str_split__rest"
	unset _bobshell_str_split__rest _bobshell_str_split__separator
	bobshell_result_ok
}

bobshell_reverse() {
	bobshell_str_split "$@"
}