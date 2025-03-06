

shelduck import ./locator/parse.sh
shelduck import ./resource/copy.sh
shelduck import string.sh

# fun: bobshell_encrypt PASSWORD SRC DEST
# use: bobshell_encrypt val:qwerty file:plain.txt file:encrypted.txt
bobshell_encrypt() {
	openssl_enc_password=
	bobshell_resource_copy "$1" var:openssl_enc_password
	shift

	bobshell_locator_parse "$1" bobshell_encrypt_source_type      bobshell_encrypt_source_ref
	bobshell_locator_parse "$2" bobshell_encrypt_destination_type bobshell_encrypt_destination_ref
	
	if [   "$bobshell_encrypt_source_type" = file  ] && [ "$bobshell_encrypt_destination_type" = file ]; then
		if [ "$1" = "$2" ]; then
			bobshell_encrypt_temp=$(mktemp)
			bobshell_openssl_enc -in "$bobshell_encrypt_source_ref" -out "$bobshell_encrypt_temp"
			bobshell_resource_copy "file:$bobshell_encrypt_temp" "$2"
			rm -f "$bobshell_encrypt_temp"
		else
			bobshell_openssl_enc -in "$bobshell_encrypt_source_ref" -out "$bobshell_encrypt_destination_ref"
		fi
	elif [ "$bobshell_encrypt_source_type" = file  ] && [ "$bobshell_encrypt_destination_type" = stdout ]; then
		bobshell_openssl_enc -in "$bobshell_encrypt_source_ref"
	elif [ "$bobshell_encrypt_source_type" = stdin ] && [ "$bobshell_encrypt_destination_type" = file ]; then
		bobshell_openssl_enc -out "$bobshell_encrypt_destination_ref"
	else
		bobshell_encrypt_result=$(bobshell_resource_copy "$1" stdout: | bobshell_openssl_enc)
		bobshell_resource_copy var:bobshell_encrypt_result "$2"
		unset bobshell_encrypt_result
	fi
}



# fun: bobshell_openssl_enc [ARG...]
# use: openssl_enc_password=qwerty; echo message | bobshell_openssl_enc | bobshell_openssl_enc -d # gives message
bobshell_openssl_enc() {
	openssl enc -aes-256-cbc -pbkdf2 -base64 -pass "pass:$openssl_enc_password" "$@"
}



# fun: bobshell_decrypt PASSWORD SRC DEST
# use: bobshell_decrypt val:qwerty file:encrypted.txt file:decrypted.txt
bobshell_decrypt() {
	openssl_enc_password=
	bobshell_resource_copy "$1" var:openssl_enc_password
	shift

	bobshell_locator_parse "$1" bobshell_decrypt_source_type      bobshell_decrypt_source_ref
	bobshell_locator_parse "$2" bobshell_decrypt_destination_type bobshell_decrypt_destination_ref
	

	if [   "$bobshell_decrypt_source_type" = file  ] && [ "$bobshell_decrypt_destination_type" = file ]; then
		if [ "$1" = "$2" ]; then
			bobshell_decrypt_temp=$(mktemp)
			bobshell_resource_copy "$1" "file:$bobshell_decrypt_temp"
			bobshell_openssl_enc -d -in "$bobshell_decrypt_temp" -out "$bobshell_decrypt_destination_ref"
			rm -f "$bobshell_decrypt_temp"
		else
			bobshell_openssl_enc -d -in "$bobshell_decrypt_source_ref" -out "$bobshell_decrypt_destination_ref"
		fi
	elif [ "$bobshell_decrypt_source_type" = file  ] && [ "$bobshell_decrypt_destination_type" = stdout ]; then
		bobshell_openssl_enc -d -in "$bobshell_decrypt_source_ref"
	elif [ "$bobshell_decrypt_source_type" = stdin ] && [ "$bobshell_decrypt_destination_type" = file ]; then
		(cat; printf '\n') | bobshell_openssl_enc -d -out "$bobshell_decrypt_destination_ref"
	else
		bobshell_decrypt_result=$(bobshell_resource_copy "$1" stdout: | { cat; printf '\n'; } | bobshell_openssl_enc -d)
		bobshell_resource_copy var:bobshell_decrypt_result "$2"
		unset bobshell_decrypt_result
	fi
}
