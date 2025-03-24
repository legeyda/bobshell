



shelduck import ../assert.sh
shelduck import ./decode.sh



test_decode() {
	assert_equals hello "$(bobshell_base64_decode val:aGVsbG8K stdout:)"
}