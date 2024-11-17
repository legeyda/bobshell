


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






# txt: 
deploy_ensure_secret_password() {
	notrace 'deploy_ensure_secret_password_not_empty="${PAYREGISTRY_DEPLOY_SECRET_PASSWORD:+yes}"'
	if [ "${deploy_ensure_secret_password_not_empty:-no}" != yes ]; then
    deploy_ensure_secret_password_tty="$(tty)"
    assert_not_empty "$deploy_ensure_secret_password_tty" 'terminal not found, not interactive shell?'
    printf %s "Password for secrets:" > "$(tty)"
		read_secret PAYREGISTRY_DEPLOY_SECRET_PASSWORD
	fi
}




trap_exit_on_error() {
  trap '[ $? -eq 0 ] && exit; '"$*" EXIT
}