# use: notrace echo hello
# txt: выполнить команду, скрывая трассировку от set -x
bobshell_notrace() {
	{ eval "$*"; } 2> /dev/null # todo eval "$*" -> "$@"
}



