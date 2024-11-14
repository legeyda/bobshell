# use: notrace echo hello
# txt: выполнить команду, скрывая трассировку от set -x
bobshell_notrace() {
	{ "$@"; } 2> /dev/null
}



