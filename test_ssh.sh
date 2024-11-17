

shelduck import ssh.sh
shelduck import assert.sh
shelduck import string.sh




# fun: run_sshd PASSWORD
run_sshd() {
	stop_sshd || true

	ssh_user=bobshell-test-user
	ssh_host=localhost
	BOBSHELL_SSH_PORT=2222


	if [ "$ssh_password_enabled" = true ]; then
		
		ssh_identity=
		ssh_public_key=
	else
		ssh_password=
		bobshell_ssh_keygen target/test-ssh/valid-ssh-key
		bobshell_copy_private_key target/test-ssh/valid-ssh-key var:ssh_identity
		bobshell_copy_public_key target/test-ssh/valid-ssh-key var:ssh_public_key
	fi
	docker run --detach --name bobshell-test-sshd --rm --publish "127.0.0.1:$BOBSHELL_SSH_PORT:2222" \
			-e PRIVATE_KEY="${ssh_identity:-}" \
			-e PUBLIC_KEY="${ssh_public_key:-}" \
			-e USER_NAME=$ssh_user \
			-e PASSWORD_ACCESS="${ssh_password_enabled}" \
			-e USER_PASSWORD="${ssh_password:-}" \
			linuxserver/openssh-server:9.7_p1-r4-ls172
	trap stop_sshd EXIT
	sleep 3



	BOBSHELL_SSH_KNOWN_HOSTS=$(ssh_keyscan $ssh_host)

	
}


stop_sshd() {
	docker stop bobshell-test-sshd
}

ssh_keyscan() {
	for bobshell_ssh_keyscan_host in "$@"; do
		bobshell_ssh_keyscan_addr=$(dig +short "$bobshell_ssh_keyscan_host")
		set -- "$@" "$bobshell_ssh_keyscan_addr"
	done
	unset bobshell_ssh_keyscan_host bobshell_ssh_keyscan_addr
	ssh-keyscan -p "$BOBSHELL_SSH_PORT" "$@"
}



test_password() {
	ssh_password_enabled=true
	ssh_password=123
	run_sshd
	BOBSHELL_SSH_PASSWORD=123 bobshell_ssh "$ssh_user@$ssh_host" 'echo hello'
}


test_password_known_hosts_file() {
	ssh_password_enabled=true
	ssh_password=123
	run_sshd

	file=$(mktemp)
	printf %s "$BOBSHELL_SSH_KNOWN_HOSTS" > "$file"
	BOBSHELL_SSH_KNOWN_HOSTS=
	BOBSHELL_SSH_KNOWN_HOSTS_FILE="$file"

	BOBSHELL_SSH_PASSWORD=123 bobshell_ssh "$ssh_user@$ssh_host" 'echo hello'
}

test_identity() {
	ssh_password_enabled=false
	run_sshd
	BOBSHELL_SSH_IDENTITY="$ssh_identity" bobshell_ssh "$ssh_user@$ssh_host" 'echo hello'
}

test_identity_file() {
	ssh_password_enabled=false
	run_sshd
	file=$(mktemp)
	printf %s "$ssh_identity" > "$file"
	BOBSHELL_SSH_IDENTITY_FILE="$file" bobshell_ssh "$ssh_user@$ssh_host" 'echo hello'
}

#bobshell_pipe file:x file:y -- cat