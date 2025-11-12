

shelduck import ../base.sh

shelduck import ../result/insert.sh
shelduck import ../result/set.sh
shelduck import ../result/isset.sh

# fun: find_each LISTENFUNC [FINDARGS...]
find_each() {
	_find_each__handler="$1"
	shift

	_find_each__separator='[fcf039cd-eb59-4c29-90d9-c1d1425f88bc 8b94f1c5-e4d7-45e7-adf8-e6a52d6f3a3c f3f31930-483e-4e93-89a5-8fd0d21887e4]'
	_temp_file_path__pipe=$(temp_file_path)
	mkfifo "$_temp_file_path__pipe"
	(
		find "$@" -printf "%p\n$_find_each__separator\n"
		printf '\n'
	) > "$_temp_file_path__pipe" &



	find_each_item=
	find_each_index=0
	while IFS= read -r _find_each__line; do
		if [ "$_find_each__line" = "$_find_each__separator" ]; then
			find_each_index=$(( find_each_index + 1))
			bobshell_result_set true
			"$_find_each__handler" "$find_each_item" "$find_each_index"
			if bobshell_result_isset; then
				if [ "$bobshell_result_1" = false ]; then
					bobshell_result_insert 2 "find_each: error calling handler $_find_each__handler for <$find_each_item>"
					break
				elif [ "$bobshell_result_1" = true ] && [ "$bobshell_result_size" -gt 1 ]; then
					if [ "$bobshell_result_2" = 'break' ]; then
						bobshell_result_set true "$find_each_index"
						break
					elif [ "$bobshell_result_2" = 'continue' ]; then
						true
					else
						bobshell_result_set false 'find_each: wrong result'
					fi
				fi
			fi
			find_each_item=
		elif [ -z "$find_each_item" ]; then 
			find_each_item="$_find_each__line"
		else
			find_each_item="$find_each_item$bobshell_newline$_find_each__line"
		fi
	done < "$_temp_file_path__pipe"

	rm "$_temp_file_path__pipe"
	bobshell_result_set true "$find_each_index"
	unset _find_each__handler _find_each__separator _find_each__line find_each_item find_each_index _temp_file_path__pipe
}

temp_file_path() {
	printf %s "${TMPDIR:-/tmp}/"
	rand_name
}


rand_name() {
	_rand_name="$(date +%Y-%m-%d_%H-%M-%S_%N_)"
	printf %s "$_rand_name"
	unset _rand_name
	openssl rand -hex 16
}