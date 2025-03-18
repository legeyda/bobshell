
shelduck import ../base.sh
shelduck import ./assert_isset.sh
shelduck import ./size.sh
shelduck import ../result/assert.sh

# fun: bobshell_array_push ARRAYNAME VALUE
bobshell_array_add() {
	bobshell_array_assert_isset "$1"
	
	bobshell_array_size "$1"
	bobshell_result_assert _bobshell_array_add__size
	_bobshell_array_add__size=$(( _bobshell_array_add__size + 1 ))

	bobshell_putvar "${1}_size" "$_bobshell_array_add__size"
	bobshell_putvar "${1}_$_bobshell_array_add__size" "$2"

	unset _bobshell_array_add__size
}
