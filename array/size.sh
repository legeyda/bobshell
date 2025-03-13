
shelduck import ../base.sh
shelduck import ./assert_isset.sh

bobshell_array_size() {
	bobshell_array_assert_isset "$1"
	bobshell_getvar "${1}_size" 0
}