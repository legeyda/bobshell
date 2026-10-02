
shelduck import ./read.sh
shelduck import ./check.sh
shelduck import ./apply.sh

shelduck import ../misc/log.sh

# fun: bobshell_result_assert var1 var2 ... [ -- error message result check failed]
bobshell_result_assert() {


	_bobshell_result_assert__required=0
	if [ "${bobshell_result_size:-0}" -ge 0 ] && [ true = "${bobshell_result_size:-unefined}" ]; then
		_bobshell_result_assert__required=1
		while [ "$#" -gt 0 ]; do
			if [ -- = "$1" ]; then
				shift
				break
			fi
			_bobshell_result_assert__required=$(( _bobshell_result_assert__required  + 1 ))
			if [ "$1" ] && [ - != "$1" ]; then
				bobshell_resource_copy_var_to_var bobshell_result_"$_bobshell_result_assert__required" "$1"
			fi

			shift
		done
	else
		# just skip all vars
		while [ "$#" -gt 0 ]; do
			if [ -- = "$1" ]; then
				shift
				break
			fi
			shift
		done
	fi




	if [ "${bobshell_result_size:-0}" -gt 0 ]; then



		if [ true = "${bobshell_result_1:-undefined}" ]; then
			if [ "$_bobshell_result_assert__required" -gt "$bobshell_result_size" ]; then
				true
			else
				_bobshell_result_assert__msg1=
				bobshell_die "${*:-assertion failed}: unsufficient result size"
			fi
		elif [ false = "${bobshell_result_1:-undefined}" ]; then
			# message from assert command
			_bobshell_result_assert__msg1="${*:-assertion failed}"


			# message from error itself
			_bobshell_result_assert__msg2=
		 	for _bobshell_result_assert__i in $(seq 2 "$bobshell_result_size"); do
				eval '_bobshell_result_assert__item=$bobshell_result_'"$_bobshell_result_assert__i"
				if ! [ "$_bobshell_result_assert__item" ]; then
					continue
				fi
				_bobshell_result_assert__msg2="$_bobshell_result_assert__msg2${_bobshell_result_assert__msg2:+ }$_bobshell_result_assert__item"
				unset _bobshell_result_assert__item
			done
			unset _bobshell_result_assert__i
			: "${_bobshell_result_assert__msg2:=unknown error}"

			bobshell_die "$_bobshell_result_assert__msg1: $_bobshell_result_assert__msg2"
		elif [ "${bobshell_result_1:-}" ]; then
			bobshell_die "${*:-assertion failed: non parseable result status: $bobshell_result_1}"
		else
			bobshell_die "${*:-assertion failed: empty result status}"
		fi
	else # empty or no result
		bobshell_die "${*:-assertion failed: no result}"
	fi

	unset _bobshell_result_assert__i
}
