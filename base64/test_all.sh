



shelduck import ../assert.sh
shelduck import ./encode.sh
shelduck import ./decode.sh



test_base64() {

	rm -rf   target/test_base64
	mkdir -p target/test_base64
	cd       target/test_base64

	bobshell_base64_encode file:/bin/sh file:encoded.txt
	bobshell_base64_decode file:encoded.txt file:decoded
	chmod +x decoded
	assert_equals hello "$(./decoded -c 'echo hello')"
	
}