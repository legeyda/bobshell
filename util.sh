

shelduck import base.sh
shelduck import string.sh
shelduck import git.sh

bobshell_unset_scope() {
	for bobshell_unset_scope_argument in "$@"; do
		for bobshell_unset_scope_name in $(bobshell_var_names | grep "^$bobshell_unset_scope_argument" || true); do
			unset "$bobshell_unset_scope_name"
		done
	done
	unset bobshell_unset_scope_argument bobshell_unset_scope_name
}

# fun: bobshell_copy_scope RUNDOODLE_GIT_SSH_ BOBSHELL_SSH_
bobshell_copy_scope() {
	bobshell_unset_scope "$2"
	for bobshell_copy_scope_name in $(bobshell_var_names | grep "^$1" || true); do
		if bobshell_isset "$bobshell_copy_scope_name"; then
			bobshell_copy_scope_value=$(bobshell_getvar "$1")
			bobshell_putvar "$bobshell_copy_scope_name" "$bobshell_copy_scope_value"
		fi
	done
}


bobshell_var_names() {
	set | sed --silent --regexp-extended 's/^([A-Za-z_][A-Za-z_0-9]*)=.*$/\1/pg' | sort
}

bobshell_current_seconds() {
	date +%s
}



# fun: save_output VARIABLE COMMAND [ARG...]
bobshell_save_output() {
	save_output_var="$1"
	shift
	save_output=$("$@")
	bobshell_putvar "$save_output_var" "$save_output"
	unset save_output_var save_output
}



bobshell_eval_output() {
	# stdout:cat
	# stdin:cat
	# todo: copy_resource "stdout:$*" "eval:"
	bobshell_eval_output=$("$@")
	eval "$bobshell_eval_output"
	unset bobshell_eval_output
}


# txt: read -sr 
bobshell_read_secret() {
  # https://github.com/biox/pa/blob/main/pa
  [ -t 0 ] && stty -echo
	read -r "$1"
	[ -t 0 ] &&  stty echo
}



bobshell_run_url() {
	if bobshell_command_available "$1"; then
		"$@"
	elif [ -z "$1" ]; then
		"$@"
	elif bobshell_ends_with "$1" '.git'; then
		bobshell_run_url_git "$@"
	else
		bobshell_die "bobshell_run_url: unrecognized parameters: $(boshell_quote "$@")"
	fi
}

bobshell_run_url_git() {
	bobshell_run_url_git_dir=$(mktemp -d)
	bobshell_git clone "$1" "$bobshell_run_url_git_dir"
	"$bobshell_run_url_git_dir/run" "$@"
}

