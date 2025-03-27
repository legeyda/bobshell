

shelduck import ./val_to_var.sh
shelduck import ../assert.sh

test_val_to_var() {
	x="123 '"' "xyz'
	y="$x"
	bobshell_append_val_to_var "$x" x
	assert_equals "$y$y" "$x"
}