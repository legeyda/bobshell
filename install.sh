
shelduck import string.sh
shelduck import scope.sh

bobshell_install_init() {
	# https://www.gnu.org/prep/standards/html_node/Directory-Variables.html#Directory-Variables

	: "${BOBSHELL_INSTALL_DESTDIR:=}"

	if [ 0 = "$(id -u)" ]; then
		: "${BOBSHELL_INSTALL_PREFIX:=/opt}"
		: "${BOBSHELL_INSTALL_SYSCONFDIR:=$BOBSHELL_INSTALL_PREFIX/etc}"
		: "${BOBSHELL_INSTALL_PROFILE_FILE:=/etc/profile}"
		: "${BOBSHELL_INSTALL_CACHEDIR:=/var/opt/cache}"
		: "${BOBSHELL_INSTALL_LOCALSTATEDIR:=$BOBSHELL_INSTALL_PREFIX/var}"
		: "${BOBSHELL_INSTALL_SYSTEMDDIR:=/etc/systemd/system}"
	else
		: "${BOBSHELL_INSTALL_PREFIX:=$HOME/.local}"
		: "${BOBSHELL_INSTALL_SYSCONFDIR:=$HOME/.config}"
		: "${BOBSHELL_INSTALL_PROFILE_FILE:=$HOME/.profile}"
		: "${BOBSHELL_INSTALL_CACHEDIR:=$HOME/.cache}"
		: "${BOBSHELL_INSTALL_LOCALSTATEDIR:=$BOBSHELL_INSTALL_PREFIX/var}"
		: "${BOBSHELL_INSTALL_SYSTEMDDIR:=$HOME/.config/systemd/user}"
	fi

	: "${BOBSHELL_INSTALL_BINDIR:=$BOBSHELL_INSTALL_PREFIX/bin}"
	: "${BOBSHELL_INSTALL_DATADIR:=$BOBSHELL_INSTALL_PREFIX/share}"

	: "${BOBSHELL_INSTALL_SYSTEMCTL:=systemctl}"

}



# fun: bobshell_install_binary SRCPATH [DESTNAME]
# use: bobshell_install_binary target/exesrc.sh mysuperprog
bobshell_install_executable() {
	bobshell_install_executable_dir="$BOBSHELL_INSTALL_DESTDIR$BOBSHELL_INSTALL_BINDIR"
	mkdir -p "$bobshell_install_executable_dir"
	bobshell_copy "$1" "file:$bobshell_install_executable_dir/$2"
	chmod u=rwx,go=rx  "$bobshell_install_executable_dir/$2"
}



# fun: bobshell_install_data SRCLOCATOR DESTNAME
# use: bobshell_install_data file:target/exesrc.sh mysuperprogdata
bobshell_install_data() {
	bobshell_install_data_dir="$BOBSHELL_INSTALL_DESTDIR$BOBSHELL_INSTALL_DATADIR/$BOBSHELL_INSTALL_NAME"
	mkdir -p "$bobshell_install_data_dir"
	bobshell_copy "$1" "file:$bobshell_install_data_dir/$2"
	chmod u=rw,go=r "$bobshell_install_data_dir/$2"
}



bobshell_install_config() {
	bobshell_install_config_dir="$BOBSHELL_INSTALL_DESTDIR$BOBSHELL_INSTALL_SYSCONFDIR/$BOBSHELL_INSTALL_NAME"
	mkdir -p "$bobshell_install_config_dir"
	bobshell_copy "$1" "file:$bobshell_install_config_dir/$2"
	chmod u=rw,go=r "$bobshell_install_config_dir/$2"
}


# fun: bobshell_install_service SRCLOCATOR DESTNAME
# use: bobshell_install_service file:target/myservice myservice.service
bobshell_install_service() {
	bobshell_install_service_dir="$BOBSHELL_INSTALL_DESTDIR$BOBSHELL_INSTALL_SYSTEMDDIR"
	mkdir -p "$bobshell_install_service_dir"
	bobshell_copy "$1" "file:$bobshell_install_service_dir/$2"

	if [ 0 = "$(id -u)" ]; then
		bobshell_install_service_arg=
	else
		bobshell_install_service_arg='--user'
	fi
	
	$BOBSHELL_INSTALL_SYSTEMCTL $bobshell_install_service_arg daemon-reload
	$BOBSHELL_INSTALL_SYSTEMCTL $bobshell_install_service_arg enable "$2"
}



bobshell_install_dirs() {
	mkdir -p "$BOBSHELL_INSTALL_DESTDIR$BOBSHELL_INSTALL_BINDIR" 
	for bobshell_install_dirs_item in "$BOBSHELL_INSTALL_DATADIR" "$BOBSHELL_INSTALL_LOCALSTATEDIR" "$BOBSHELL_INSTALL_CACHEDIR"; do
		mkdir -p "$BOBSHELL_INSTALL_DESTDIR$bobshell_install_dirs_item/$BOBSHELL_INSTALL_NAME"
	done
}



bobshell_uninstall() {
	for dir in "$BOBSHELL_INSTALL_BINDIR" "$BOBSHELL_INSTALL_DATADIR" "$BOBSHELL_INSTALL_LOCALSTATEDIR" "$BOBSHELL_INSTALL_CACHEDIR"; do
		rm -rf "$BOBSHELL_INSTALL_DESTDIR$dir/$BOBSHELL_INSTALL_NAME"
	done
}