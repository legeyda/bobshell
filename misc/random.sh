
shelduck import ../random/int.sh
shelduck import ../result/assert.sh

# DEPRECATED: use bobshell_random_int
bobshell_random() {
	bobshell_random_int
	bobshell_result_assert _bobshell_random
	printf %s "$_bobshell_random"
}
