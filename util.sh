

shelduck import base.sh
shelduck import string.sh
shelduck import git.sh
shelduck import resource/copy.sh
shelduck import ./eval.sh

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
	_bobshell_preserve_env=
	for _x in $(set | sed -n "s/^\([A-Za-z_][A-Za-z0-9_]*\)=.*$/\1/pg"); do
		if ! bobshell_isset "$_x"; then
			continue
		fi
		_v=$(bobshell_getvar "$_x")
		_v=$(bobshell_quote "$_v")
		_bobshell_preserve_env="$_bobshell_preserve_env
bobshell_preserve_env_item_load $_x $_v"
	done
	unset _x
	"$@"
	eval "$_bobshell_preserve_env"
	unset _bobshell_preserve_env
}

bobshell_preserve_env_item_load() {
	if bobshell_isset "$1"; then
		_x=$(bobshell_getvar "$1")
		if [ "$_x" = "$2" ]; then
			return
		fi
		bobshell_putvar "$1" "$2"
	fi
}


bobshell_is_root() {
	test 0 = "$(id -u)"
}

bobshell_is_not_root() {
	test 0 != "$(id -u)"
}

# fun: shelduck_eval_with_args SCRIPT [ARGS...]
# todo 
shelduck_eval_with_args() { 
	shelduck_eval_with_args_script="$1"
	shift
	eval "$shelduck_eval_with_args_script"
}


bobshell_uid() {
	id -u
}

bobshell_gid() {
	id -g
}


bobshell_user_name() {
	printf %s "$USER" # todo
}



bobshell_user_home() {
	printf %s "$HOME" # todo
}

bobshell_get_file_mtime() {

	# LC_TIME=en_US.UTF-8 ls -ld ./pom.xml | sed -n 's/^.* \([A-Z][a-z]\{2\} \+[0-9]\+\).*$/\1/p'
	#LC_TIME=en_US.UTF-8 ls -ld ./pom.xml | sed -n 's/^.* \(\(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec\) \+[0-9]\+ \+\).*$/\1/p'

	LC_TIME=en_US.UTF-8 ls -ld ./pom.xml | sed -n 's/^.* \(\(Jan\|Feb\|Mar\|Apr\|May\|Jun\|Jul\|Aug\|Sep\|Oct\|Nov\|Dec\) \+[1-9]\+ \+[0-9]\+\:[0-9]\+\).*$/\1/p'
	# 

	bobshell_get_file_mtime_dirname=$(dirname "$1")
	bobshell_get_file_mtime_basename=$(basename "$1")
	find "$bobshell_get_file_mtime_dirname" -maxdepth 1 -name "$bobshell_get_file_mtime_basename" -printf "%Ts"
	unset bobshell_get_file_mtime_dirname bobshell_get_file_mtime_basename
}

# bobshell_line_in_file: 
bobshell_line_in_file() {
	true
}

