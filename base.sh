
shelduck import string.sh

bobshell_die() {
  # https://github.com/biox/pa/blob/main/pa
  printf '%s: %s.\n' "$(basename "$0")" "${*:-error}" >&2
  exit 1
}


# use isset unreliablevar
bobshell_isset() {
	eval "test \"\${$1+defined}\" = defined"
}

#  
bobshell_isset_1() {
	eval "test \"\${1+defined}\" = defined"
}

bobshell_isset_2() {
	eval "test \"\${2+defined}\" = defined"
}

bobshell_isset_3() {
	eval "test \"\${3+defined}\" = defined"
}

bobshell_command_available() {
	command -v "$1" > /dev/null
}

# fun: bobshell_putvar VARNAME NEWVARVALUE
# txt: установка значения переменной по динамическому имени
bobshell_putvar() {
  eval "$1=\"\$2\""
}



# fun bobshell_getvar VARNAME
# use: echo "$(getvar MSG)"
# txt: считывание значения переменной по динамическому имени
bobshell_getvar() {
  eval "printf %s \"\$$1\""
}


bobshell_require_not_empty() {
	if [ -z "${1:-}" ]; then
		shift
		bobshell_die "$@"
	fi
}

bobshell_require_empty() {
	if [ -z "${1:-}" ]; then
		shift
		bobshell_die "$@"
	fi
}


bobshell_is_bash() {
	test -n "${BASH_VERSION:-}"
}

bobshell_is_zsh() {
	test -n "${ZSH_VERSION:-}"
}

bobshell_is_ksh() {
	test -n "${KSH_VERSION:-}"
}

bobshell_list_functions() {
	if bobshell_is_bash; then
		compgen -A function
	elif [ -n "${0:-}" ] && [ -f "${0}" ]; then
		sed --regexp-extended 's/^( *function)? *([A-Za-z0_9_]+) *\( *\) *\{ *$/\2/g' "$0"
	fi
}

bobshell_log() {
	# printf format should be in "$@"
	# shellcheck disable=SC2059
	bobshell_log_message=$(printf "$@")
	printf '%s: %s\n' "$0" "$bobshell_log_message" >&2
	unset bobshell_log_message
}

bobshell_rename_var() {
	if [ "$1" = "$2" ]; then
		return
	fi
	eval "$2=\$$1"
	unset "$1"
}

bobshell_vars() {
	bobshell_vars_list=$(set | sed -n 's/^\([A-Za-z_][A-Za-z_0-9]*\)=.*$/\1/pg' | sort -u)
	for bobshell_vars_item in $bobshell_vars_list; do
		if bobshell_isset "$bobshell_vars_item"; then
			printf '%s ' "$bobshell_vars_item"
		fi
	done
	unset bobshell_vars_list
}

# bobshell_not_empty "$@"
bobshell_not_empty() {
	test set = "${1+set}" 
}

#bobshell_map

# fun: bobshell_foreach ITEM... -- COMMAND [ARG...]
# bobshell_foreach() {
# 	bobshell_foreach_items=
# 	bobshell_foreach_command=
# 	while bobshell_not_empty "$@"; do
# 		if [ '--' = "$1" ]; then
# 			shift
# 			set -- "$@"
# 			break
# 		fi
# 		bobshell_foreach_item=$(bobshell_quote "$1")
# 		bobshell_foreach_items="$bobshell_foreach_items $1"
# 		shift
# 	done

# 	bobshell_require_not_empty "$bobshell_foreach_command" "bobshell_foreach: command not set"

# 	for bobshell_foreach_item in $bobshell_foreach_items; do
# 		"$@" "$bobshell_foreach_item"
# 	done
# 	unset bobshell_foreach_item

# 	unset bobshell_foreach_items bobshell_foreach_command
# }