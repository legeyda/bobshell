
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
	else
		: "${BOBSHELL_INSTALL_PREFIX:=$HOME/.local}"
		: "${BOBSHELL_INSTALL_SYSCONFDIR:=$HOME/.config}"
		: "${BOBSHELL_INSTALL_PROFILE_FILE:=$HOME/.profile}"
		: "${BOBSHELL_INSTALL_CACHEDIR:=$HOME/.cache}"
		: "${BOBSHELL_INSTALL_LOCALSTATEDIR:=$BOBSHELL_INSTALL_PREFIX/var}"
	fi

	: "${BOBSHELL_INSTALL_BINDIR:=$BOBSHELL_INSTALL_PREFIX/bin}"
	: "${BOBSHELL_INSTALL_DATADIR:=$BOBSHELL_INSTALL_PREFIX/share}"

}

# fun: bobshell_install_binary SRCPATH [DESTNAME]
# use: bobshell_install_binary target/exesrc.sh mysuperprog
bobshell_install_executable() {
	mkdir -p "$BOBSHELL_INSTALL_DESTDIR$BOBSHELL_INSTALL_BINDIR"
	install --no-target-directory --mode=u=rwx,go=rx "$1" "$BOBSHELL_INSTALL_DESTDIR$BOBSHELL_INSTALL_BINDIR${2:-$BOBSHELL_INSTALL_NAME}"
}

# fun: bobshell_install_data SRCPATH DESTNAME
# use: bobshell_install_data target/exesrc.sh mysuperprogdata
bobshell_install_data() {
	mkdir -p "$BOBSHELL_INSTALL_DESTDIR$BOBSHELL_INSTALL_DATADIR/$BOBSHELL_INSTALL_NAME"
	install --no-target-directory --mode=u=rw,go=r "$1" "$BOBSHELL_INSTALL_DESTDIR$BOBSHELL_INSTALL_DATADIR/$BOBSHELL_INSTALL_NAME/$2"
}

bobshell_install_config() {
	mkdir -p "$BOBSHELL_INSTALL_DESTDIR$BOBSHELL_INSTALL_SYSCONFDIR/$BOBSHELL_INSTALL_NAME"
	install --no-target-directory --mode=u=rw,go=r "$1" "$BOBSHELL_INSTALL_DESTDIR$BOBSHELL_INSTALL_SYSCONFDIR/$BOBSHELL_INSTALL_NAME/$2"
}


bobshell_install_dirs() {
	for dir in "$BOBSHELL_INSTALL_DATADIR" "$BOBSHELL_INSTALL_LOCALSTATEDIR" "$BOBSHELL_INSTALL_CACHEDIR"; do
		mkdir -p "$BOBSHELL_INSTALL_DESTDIR$dir/$BOBSHELL_INSTALL_NAME"
	done
}

bobshell_uninstall() {
	for dir in "$BOBSHELL_INSTALL_DATADIR" "$BOBSHELL_INSTALL_LOCALSTATEDIR" "$BOBSHELL_INSTALL_CACHEDIR"; do
		rm -rf "$BOBSHELL_INSTALL_DESTDIR$dir/$BOBSHELL_INSTALL_NAME"
	done
}