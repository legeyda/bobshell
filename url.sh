# shellcheck disable=SC2148

shelduck import ./base.sh
shelduck import ./string.sh


bobshell_fetch_url() {
	if bobshell_remove_prefix "$1" 'file://' bobshell_fetch_url_path; then
		# shellcheck disable=SC2154
		# bobshell_remove_prefix sets variable bobshell_fetch_url_path indirectly
		cat "$bobshell_fetch_url_path"
		unset bobshell_fetch_url_path
	elif bobshell_command_available curl; then
		bobshell_fetch_url_with_curl "$1"
	elif bobshell_command_available wget; then
		bobshell_fetch_url_with_wget "$1"
	else
		bobshell_die 'error: neither curl nor wget installed'
	fi
}

# fun: bobshell_base_url http://domain/dir/file # prints http://domain/dir/
bobshell_base_url() {
	printf %s/ "${1%/*}"
}


# fun: bobshell_resolve_url URL [BASEURL]
bobshell_resolve_url() {
	# todo by default BASEURL is $(realpath "$(pwd)")
	if bobshell_starts_with "$1" /; then
		bobshell_resolve_url_path=$(realpath "$1")
		printf 'file://%s' "$bobshell_resolve_url_path"
	elif bobshell_remove_prefix "$1" file:// bobshell_resolve_url_path; then
		bobshell_resolve_url_path=$(realpath "$bobshell_resolve_url_path")
		printf 'file://%s' "$bobshell_resolve_url_path"
	elif bobshell_starts_with "$1" http:// \
	  || bobshell_starts_with "$1" https:// \
	  || bobshell_starts_with "$1" ftp:// \
	  || bobshell_starts_with "$1" ftps:// \
			; then
		printf %s "$1"
	else
		if bobshell_isset_2 "$@"; then
			bobshell_resolve_url_base="$2"	
			while bobshell_remove_suffix "$bobshell_resolve_url_base" / bobshell_resolve_url_base; do
				true
			done
		else
			bobshell_resolve_url_base=$(pwd)
		fi

		bobshell_resolve_url_value="$1"
		while bobshell_remove_prefix "$bobshell_resolve_url_value" './' bobshell_resolve_url_value; do
			true
		done


		while bobshell_remove_prefix "$bobshell_resolve_url_value" '../' bobshell_resolve_url_value; do
			if ! bobshell_split_last "$bobshell_resolve_url_base" / bobshell_resolve_url_base; then
				bobshell_die "bobshell_resolve_url: base=$bobshell_resolve_url_base, url=$bobshell_resolve_url_value"
			fi
		done

		printf '%s/%s' "$bobshell_resolve_url_base" "$bobshell_resolve_url_value"
		unset bobshell_resolve_url_base bobshell_resolve_url_value
	fi
}

bobshell_fetch_url_with_curl() {
	curl --fail --silent --show-error --location "$1"
}

bobshell_fetch_url_with_wget() {
	wget --no-verbose --output-document -
}
