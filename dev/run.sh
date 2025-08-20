

shelduck import ../base.sh
shelduck import ../run.sh
shelduck import ./version.sh
shelduck import ./tag.sh

bobshell_dev_run_start_listener() {
	bobshell_dev_version --allow-snapshot
	bobshell_result_check bobshell_dev_version

	bobshell_dev_tag
	bobshell_result_check bobshell_dev_tag || true
}


bobshell_run_listen start bobshell_dev_run_start_listener


do_build() {
	bobshell_die 'do_build: not implemented, should be overriden'
}

do_deploy() {
	echo 'deploy not configured, override do_deploy to deploy artifacts, e.g. push docker images' >&2
}

do_release() {
	gh release create --title "Release $bobshell_dev_tag" \
			--generate-notes --verify-tag \
			"$bobshell_dev_tag" $bobshell_dev_artifacts
}

run_deploy() {
	do_build
	do_deploy
}

run_build() {
	do_build
}

run_release() {
	do_build
	do_release
}

run_version() {
	printf %s "$bobshell_dev_version"
}

run_ci() {
	printf 'build... '
	do_build
	printf 'ok\n'

	printf 'release... '
	bobshell_dev_tag
	if bobshell_result_check; then
		release
		printf 'ok\n'
	else
		printf 'skip\n'
	fi
}