
shelduck import ./read.sh
shelduck import ./check.sh
shelduck import ./apply.sh
shelduck import ../base.sh



bobshell_result_assert_v2() {

	_bobshell_result_assert_v2__size_required=1
	while [ "$#" -gt 0 ]; do
		if [ -- = "$1" ]; then
			shift
			break
		fi
		_bobshell_result_assert_v2__size_required=$(( _bobshell_result_assert_v2__size_required  + 1 ))
		if [ "${bobshell_result_size:-0}" -ge "$_bobshell_result_assert_v2__size_required" ]; then
			if [ "$1" ] && [ - != "$1" ]; then
				bobshell_resource_copy_var_to_var bobshell_result_"$_bobshell_result_assert_v2__size_required" "$1"
			fi
		fi
		
		shift
	done

	if [ "${bobshell_result_size:-0}" -ge "$_bobshell_result_assert_v2__size_required" ]; then
		unset _bobshell_result_assert_v2__size_required
		if [ true = "${bobshell_result_1:-undefined}" ]; then
			return
		elif [ false = "${bobshell_result_1:-undefined}" ]; then
			_bobshell_result_assert_v2__msg="$*"
		 	for _bobshell_result_assert_v2__i in $(seq 2 "$_bobshell_result_assert_v2__size_required"); do
				eval '_bobshell_result_assert_v2__item=$bobshell_result_'"$_bobshell_result_assert_v2__i"
				if [ "$_bobshell_result_assert_v2__msg" ]; then
					_bobshell_result_assert_v2__msg="$_bobshell_result_assert_v2__item"
				else
					_bobshell_result_assert_v2__msg="$_bobshell_result_assert_v2__msg $_bobshell_result_assert_v2__item"
				fi
			done
			bobshell_die "$_bobshell_result_assert_v2__msg"
		else # non-boolean result_1
			bobshell_die "${*:-(bobshell_result_)assertion failed}"
		fi
	else # empty or no result
		bobshell_die "${*:-(bobshell_result_)assertion failed}"
	fi
	unset _bobshell_result_assert_v2__size_required
	

}
