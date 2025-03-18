


shelduck import assert.sh
shelduck import crypto.sh


test_encrypt_decrypt() {
  mkcd target/test-crypto


  # encrypt_resource&decrypt_resource
  printf hello > plain.txt
  rm -f encrypted.txt decrypted.txt

  bobshell_encrypt val:123 file:plain.txt file:encrypted.txt
  assert_not_equals "$(cat plain.txt)"  "$(cat encrypted.txt)"

  bobshell_decrypt val:123 "val:$(cat encrypted.txt)" file:decrypted.txt
  assert_equals "$(cat plain.txt)" "$(cat decrypted.txt)"

}



mkcd() {
	mkdir -p "$1"
	cd "$1"

}

