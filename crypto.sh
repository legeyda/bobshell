

shelduck import locator.sh
shelduck import string.sh

# fun: bobshell_encrypt PASSWORD RESOURCE
# use: bobshell_encrypt val:qwerty file:plain.txt file:encrypted.txt
bobshell_encrypt() {
	openssl_enc_password=
	bobshell_copy "$1" var:openssl_enc_password
	shift
	
	bobshell_parse_locator "$1" bobshell_encrypt_source_type      bobshell_encrypt_source_ref
	bobshell_parse_locator "$2" bobshell_encrypt_destination_type bobshell_encrypt_destination_ref
	
	if [   "$bobshell_encrypt_source_type" = file  ] && [ "$bobshell_encrypt_destination_type" = file ]; then
		bobshell_openssl_enc -in "$bobshell_encrypt_source_ref" -out "$bobshell_encrypt_destination_ref"
	elif [ "$bobshell_encrypt_source_type" = file  ] && [ "$bobshell_encrypt_destination_type" = stdout ]; then
		bobshell_openssl_enc -in "$bobshell_encrypt_source_ref"
	elif [ "$bobshell_encrypt_source_type" = stdin ] && [ "$bobshell_encrypt_destination_type" = file ]; then
		bobshell_openssl_enc -out "$bobshell_encrypt_destination_ref"
	else
		bobshell_copy "$1" stdout: \
				| bobshell_openssl_enc	\
				| bobshell_copy stdin: "$2"
	fi
}



# fun: bobshell_openssl_enc [ARG...]
# use: openssl_enc_password=qwerty; echo message | bobshell_openssl_enc | bobshell_openssl_enc -d # gives message
bobshell_openssl_enc() {
	openssl enc -aes-256-cbc -pbkdf2 -base64 -pass "pass:$openssl_enc_password" "$@"
}



# fun: bobshell_decrypt PASSWORD RESOURCE
# use: bobshell_decrypt val:qwerty file:encrypted.txt file:decrypted.txt
bobshell_decrypt() {
	openssl_enc_password=
	bobshell_copy "$1" var:openssl_enc_password
	shift

	bobshell_parse_locator "$1" bobshell_encrypt_source_type      bobshell_encrypt_source_ref
	bobshell_parse_locator "$2" bobshell_encrypt_destination_type bobshell_encrypt_destination_ref
	

	if [   "$bobshell_encrypt_source_type" = file  ] && [ "$bobshell_encrypt_destination_type" = file ]; then
		bobshell_openssl_enc -d -in "$bobshell_encrypt_source_ref" -out "$bobshell_encrypt_destination_ref"
	elif [ "$bobshell_encrypt_source_type" = file  ] && [ "$bobshell_encrypt_destination_type" = stdout ]; then
		bobshell_openssl_enc -d -in "$bobshell_encrypt_source_ref"
	elif [ "$bobshell_encrypt_source_type" = stdin ] && [ "$bobshell_encrypt_destination_type" = file ]; then
		(cat; printf '\n') | bobshell_openssl_enc -d -out "$bobshell_encrypt_destination_ref"
	else
		bobshell_copy "$1" stdout:	    \
				| { cat; printf '\n'; }  \
				| bobshell_openssl_enc -d \
				| bobshell_copy stdin: "$2"
	fi
}

# fun: bobshell_encrypt_file_in_place val:qwerty plain.txt
bobshell_encrypt_file_in_place() {
	bobshell_require_file_exists "$2"
	bobshell_encrypt_file_in_place_temp_file=$(mktemp)
	bobshell_encrypt "$1" "file:$2" "file:$bobshell_encrypt_file_in_place_temp_file"
	bobshell_copy "file:$bobshell_encrypt_file_in_place_temp_file" "file:$2"
	rm -f "$bobshell_encrypt_file_in_place_temp_file"
}


# fun: bobshell_decrypt_file_in_place val:qwerty encrypted.txt
bobshell_decrypt_file_in_place() {
	bobshell_require_file_exists "$2"
	bobshell_starts_with "$(cat "$2")" U2FsdGVkX || bobshell_die 'file content is not encrypted'
	bobshell_decrypt_temp_file=$(mktemp)
	bobshell_decrypt "$1" "file:$2" "file:$bobshell_decrypt_temp_file"
	bobshell_copy "file:$bobshell_decrypt_temp_file" "file:$2"
}
