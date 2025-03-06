

shelduck import ./is_file.sh

# fun: bobshell_locator_resolve LOCATOR [BASELOCATOR]
bobshell_locator_resolve() {
	# todo by default BASEURL is $(realpath "$(pwd)")
	if bobshell_starts_with "$1" /; then
		_bobshell_locator_resolve__path=$(realpath "$1")
		printf 'file://%s' "$_bobshell_locator_resolve__path"
		unset _bobshell_locator_resolve__path
	elif bobshell_remove_prefix "$1" file:// _bobshell_locator_resolve__path; then
		_bobshell_locator_resolve__path=$(realpath "$_bobshell_locator_resolve__path")
		printf 'file://%s' "$_bobshell_locator_resolve__path"
		unset _bobshell_locator_resolve__path
	elif bobshell_starts_with "$1" http:// \
	  || bobshell_starts_with "$1" https:// \
	  || bobshell_starts_with "$1" ftp:// \
	  || bobshell_starts_with "$1" ftps:// \
			; then
		printf %s "$1"
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