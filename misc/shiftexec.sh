
bobshell_shiftexec() {
	shift "$1"
	shift
	"$@"
}