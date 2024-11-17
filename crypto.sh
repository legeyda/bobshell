

shelduck import locator.sh


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
	assert_file_exists "$1"
	bobshell_encrypt_file_in_place_temp_file=$(mktemp)
	bobshell_encrypt var:BOBSHELL_SECRET_PASSWORD "file:$1" "file:$bobshell_encrypt_file_in_place_temp_file"
	bobshell_copy "file:$bobshell_encrypt_file_in_place_temp_file" "file:$1"
	rm -f "$bobshell_encrypt_file_in_place_temp_file"
}


# fun: bobshell_decrypt_file_in_place val:qwerty encrypted.txt
bobshell_decrypt_file_in_place() {
	assert_file_exists "$1"
	starts_with "$(cat "$1")" U2FsdGVkX || bobshell_die 'file content is not encrypted'
	bobshell_decrypt_temp_file=$(mktemp)
	bobshell_decrypt var:BOBSHELL_SECRET_PASSWORD "file:$1" "file:$bobshell_decrypt_temp_file"
	bobshell_copy "file:$bobshell_decrypt_temp_file" "file:$1"
}


# txt: 
bobshell_ensure_secret_password() {
	bobshell_notrace 'deploy_ensure_secret_password_not_empty="${BOBSHELL_SECRET_PASSWORD:+yes}"'
	if [ "${deploy_ensure_secret_password_not_empty:-no}" != yes ]; then
		deploy_ensure_secret_password_tty="$(tty)"
		assert_not_empty "$deploy_ensure_secret_password_tty" 'terminal not found, not interactive shell?'
		printf %s "Password for secrets:" > "$(tty)"
		read_secret BOBSHELL_SECRET_PASSWORD
	fi
}
