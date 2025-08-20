

shelduck import ../base.sh
shelduck import ../run.sh
shelduck import ./version.sh
shelduck import ./tag.sh

bobshell_dev_run_start_listener() {
	bobshell_dev_version
	if bobshell_result_check bobshell_dev_release_version; then
		bobshell_dev_version="$bobshell_dev_release_version"
	else
		bobshell_dev_version --allow-snapshot
		bobshell_result_check bobshell_dev_version
	fi
}


bobshell_run_listen start bobshell_dev_run_start_listener


do_build() {
	bobshell_die 'do_build: not implemented, should be overriden'
}

do_deploy() {
	echo 'deploy not configured, override do_deploy to deploy artifacts, e.g. push docker images' >&2
}

do_release() {
	gh release create --title "Release v$bobshell_dev_release_version" \
			--generate-notes --verify-tag \
			"v$bobshell_dev_release_version" $bobshell_dev_artifacts
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
	if bobshell_isset bobshell_dev_release_version; then
		do_release
		printf 'ok\n'
	else
		printf 'skip\n'
	fi
}