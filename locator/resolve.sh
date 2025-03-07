

shelduck import ./is_file.sh
shelduck import ./parse.sh

# fun: bobshell_locator_resolve LOCATOR [BASELOCATOR]
bobshell_locator_resolve() {
	if  bobshell_locator_parse "$1" _bobshell_locator_resolve__type _bobshell_locator_resolve__ref; then
		if [ file = "$_bobshell_locator_resolve__type" ]; then
			_bobshell_locator_resolve__ref=$(realpath "$_bobshell_locator_resolve__ref")
		fi
		printf 'file://%s' "$_bobshell_locator_resolve__ref"
		unset _bobshell_locator_resolve__type _bobshell_locator_resolve__ref
	else
		if bobshell_isset_2 "$@"; then
			_bobshell_locator_resolve__base="$2"	
			while bobshell_remove_suffix "$_bobshell_locator_resolve__base" / _bobshell_locator_resolve__base; do
				true
			done
		else
			_bobshell_locator_resolve__base=$(pwd)
		fi

		_bobshell_locator_resolve__value="$1"
		while bobshell_remove_prefix "$_bobshell_locator_resolve__value" './' _bobshell_locator_resolve__value; do
			true
		done


		while bobshell_remove_prefix "$_bobshell_locator_resolve__value" '../' _bobshell_locator_resolve__value; do
			if ! bobshell_split_last "$_bobshell_locator_resolve__base" / _bobshell_locator_resolve__base; then
				bobshell_die "_bobshell_locator_resolve:_ base=$_bobshell_locator_resolve__base, url=$_bobshell_locator_resolve__value"
			fi
		done

		printf '%s/%s' "$_bobshell_locator_resolve__base" "$_bobshell_locator_resolve__value"
		unset _bobshell_locator_resolve__base _bobshell_locator_resolve__value
	fi
}