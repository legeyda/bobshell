



shelduck import ../assert.sh
shelduck import ./ensure_empty_dir.sh

test_ensure_empty_dir() {
	dir=$(mktemp -du)
	assert_error test -d "$dir"

	bobshell_ensure_empty_dir "$dir"
	assert_ok test -d "$dir"

	touch "$dir/file"
	bobshell_ensure_empty_dir "$dir"
	assert_ok test -d "$dir"
	assert_error test -e "$dir/file"





}