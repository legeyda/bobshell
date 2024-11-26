

shelduck import base.sh
shelduck import string.sh
shelduck import git.sh


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

# txt: выполнить команду, восстановить после неё значения переменных окружения
# use: X=1; Y=2; preserve_environment 'eval' 'X=2, Z=3'; echo "$X, $Y, $Z" # gives 1, 2, 3
bobshell_preserve_env() {
  bobshell_preserve_env_orig=
  # shellcheck disable=SC2016
  notrace eval 'bobshell_preserve_env_orig="$(set)"'
  "$@"
  notrace eval "$bobshell_preserve_env_orig"
  unset bobshell_preserve_env_orig
}

bobshell_is_root() {
	test 0 = "$(id -u)"
}

bobshell_is_not_root() {
	test 0 != "$(id -u)"
}