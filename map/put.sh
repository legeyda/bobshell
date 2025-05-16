
shelduck import ../base.sh
shelduck import ../result/set.sh
shelduck import ../result/check.sh
shelduck import ../var/get.sh
shelduck import ../var/set.sh

# bobshell_map_put mapname key value 
bobshell_map_put() {
	_bobshell_map_put__hash=$(printf %s "$2" | sed 's/[^A-Za-z_0-9]/_/g') # todo optimize somehow

	bobshell_var_get "${1}_bag_$_bobshell_map_put__hash"
	if bobshell_result_check _bobshell_map_put__bag; then
		for _bobshell_map_put__ref in $_bobshell_map_put__bag; do
			bobshell_var_get "${1}_key_$_bobshell_map_put__ref"
			bobshell_result_check _bobshell_map_put__key
			if [ "$_bobshell_map_put__key" = "$2" ]; then
				bobshell_var_set "${1}_val_$_bobshell_map_put__ref" "$3"
				unset _bobshell_map_put__hash _bobshell_map_put__bag _bobshell_map_put__ref _bobshell_map_put__key
				return
			fi
		done
		: "${_bobshell_map__counter:=0}"
		_bobshell_map__counter=$(( 1 + _bobshell_map__counter ))
		_bobshell_map_put__ref="$_bobshell_map__counter"
		_bobshell_map_put__bag="$_bobshell_map_put__bag $_bobshell_map_put__ref"
		unset _bobshell_map_put__refs _bobshell_map_put__ref _bobshell_map_put__key
	else
		: "${_bobshell_map__counter:=0}"
		_bobshell_map__counter=$(( 1 + _bobshell_map__counter ))
		_bobshell_map_put__ref="$_bobshell_map__counter"
		_bobshell_map_put__bag="$_bobshell_map_put__ref"
	fi

	bobshell_var_set "${1}_bag_$_bobshell_map_put__hash" "$_bobshell_map_put__bag"
	unset _bobshell_map_put__hash _bobshell_map_put__bag

	bobshell_var_set "${1}_key_$_bobshell_map_put__ref" "$2"
	bobshell_var_set "${1}_val_$_bobshell_map_put__ref" "$3"
	unset _bobshell_map_put__ref
}