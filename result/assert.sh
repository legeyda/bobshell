
shelduck import ./read.sh
shelduck import ./check.sh
shelduck import ./apply.sh

shelduck import ../misc/log.sh

bobshell_result_assert() {

	_bobshell_result_assert__size_required=1
	while [ "$#" -gt 0 ]; do
		if [ -- = "$1" ]; then
			shift
			break
		fi
		_bobshell_result_assert__size_required=$(( _bobshell_result_assert__size_required  + 1 ))
		if [ "${bobshell_result_size:-0}" -ge "$_bobshell_result_assert__size_required" ]; then
			if [ "$1" ] && [ - != "$1" ]; then
				bobshell_resource_copy_var_to_var bobshell_result_"$_bobshell_result_assert__size_required" "$1"
			fi
		fi

		shift
	done

	if [ "${bobshell_result_size:-0}" -ge "$_bobshell_result_assert__size_required" ]; then
		unset _bobshell_result_assert__size_required
		if [ true = "${bobshell_result_1:-undefined}" ]; then
			return
		elif [ false = "${bobshell_result_1:-undefined}" ]; then
			_bobshell_result_assert__msg="$*"
		 	for _bobshell_result_assert__i in $(seq 2 "$_bobshell_result_assert__size_required"); do
				eval '_bobshell_result_assert__item=$bobshell_result_'"$_bobshell_result_assert__i"
				if [ "$_bobshell_result_assert__msg" ]; then
					_bobshell_result_assert__msg="$_bobshell_result_assert__item"
				else
					_bobshell_result_assert__msg="$_bobshell_result_assert__msg $_bobshell_result_assert__item"
				fi
			done
			bobshell_die "$_bobshell_result_assert__msg"
		else # non-boolean result_1
			bobshell_die "${*:-assertion failed}"
		fi
	else # empty or no result
		bobshell_die "${*:-assertion failed}"
	fi
	unset _bobshell_result_assert__size_required


}
