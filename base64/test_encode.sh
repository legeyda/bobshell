



shelduck import ../assert.sh
shelduck import ./encode.sh



test_encode() {
	assert_equals aGVsbG8K "$(bobshell_base64_encode val:hello stdout:)"
}