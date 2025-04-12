
shelduck import ../../base.sh
shelduck import ../../string.sh
shelduck import ../../result/set.sh


bobshell_str_path_join() {
	if ! bobshell_isset_1 "$@"; then
		bobshell_result_set false
		return
	fi
	_bobshell_str_path_join__result="$1"
	shift
	while bobshell_isset_1 "$@"; do
		while bobshell_remove_suffix "$_bobshell_str_path_join__result" / _bobshell_str_path_join__result; do
			true
		done
		_bobshell_str_path_join__part="$1"
		shift
		while bobshell_remove_prefix "$_bobshell_str_path_join__part" / _bobshell_str_path_join__part; do
			true
		done
		_bobshell_str_path_join__result="$_bobshell_str_path_join__result/$_bobshell_str_path_join__part"
		unset _bobshell_str_path_join__part
	done
	
	bobshell_result_set true "$_bobshell_str_path_join__result"
	unset _bobshell_str_path_join__result
}