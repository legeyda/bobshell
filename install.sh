
shelduck import string.sh
shelduck import util.sh
shelduck import locator.sh


# env: BOBSHELL_INSTALL_NAME
bobshell_install_init() {
	# https://www.gnu.org/prep/standards/html_node/Directory-Variables.html#Directory-Variables
	
	if [ -z "$BOBSHELL_INSTALL_NAME" ] && [ -n "$BOBSHELL_APP_NAME" ]; then
		BOBSHELL_INSTALL_NAME="$BOBSHELL_APP_NAME"
	fi

	: "${BOBSHELL_INSTALL_DESTDIR:=}"
	: "${BOBSHELL_INSTALL_ROOT:=}"
	if [ -n "${BOBSHELL_INSTALL_ROOT:-}" ]; then
		BOBSHELL_INSTALL_ROOT=$(realpath "$BOBSHELL_INSTALL_ROOT")
	fi

	# https://refspecs.linuxfoundation.org/FHS_3.0/fhs-3.0.html
	: "${BOBSHELL_INSTALL_SYSTEM_BINDIR=${BOBSHELL_INSTALL_BINDIR-$BOBSHELL_INSTALL_ROOT/opt/bin}}"
	: "${BOBSHELL_INSTALL_SYSTEM_CONFDIR=${BOBSHELL_INSTALL_CONFDIR-$BOBSHELL_INSTALL_ROOT/etc/opt}}"
	: "${BOBSHELL_INSTALL_SYSTEM_DATADIR=${BOBSHELL_INSTALL_DATADIR-$BOBSHELL_INSTALL_ROOT/opt}}"
	: "${BOBSHELL_INSTALL_SYSTEM_LOCALSTATEDIR=${BOBSHELL_INSTALL_LOCALSTATEDIR-$BOBSHELL_INSTALL_ROOT/var/opt}}"
	: "${BOBSHELL_INSTALL_SYSTEM_CACHEDIR=${BOBSHELL_INSTALL_CACHEDIR-$BOBSHELL_INSTALL_ROOT/var/cache/opt}}"
	: "${BOBSHELL_INSTALL_SYSTEM_SYSTEMDDIR=${BOBSHELL_INSTALL_SYSTEMDDIR-$BOBSHELL_INSTALL_ROOT/etc/systemd/system}}"
	: "${BOBSHELL_INSTALL_SYSTEM_PROFILE=${BOBSHELL_INSTALL_PROFILE-$BOBSHELL_INSTALL_ROOT/etc/profile}}"

	# https://wiki.archlinux.org/title/XDG_Base_Directory
	: "${BOBSHELL_INSTALL_USER_BINDIR=${BOBSHELL_INSTALL_BINDIR-$BOBSHELL_INSTALL_ROOT$HOME/.local/bin}}"
	: "${BOBSHELL_INSTALL_USER_CONFDIR=${BOBSHELL_INSTALL_CONFDIR-$BOBSHELL_INSTALL_ROOT$HOME/.config}}"
	: "${BOBSHELL_INSTALL_USER_DATADIR=${BOBSHELL_INSTALL_DATADIR-$BOBSHELL_INSTALL_ROOT$HOME/.local/share}}"
	: "${BOBSHELL_INSTALL_USER_LOCALSTATEDIR=${BOBSHELL_INSTALL_LOCALSTATEDIR-$BOBSHELL_INSTALL_ROOT$HOME/.local/state}}"
	: "${BOBSHELL_INSTALL_USER_CACHEDIR=${BOBSHELL_INSTALL_CACHEDIR-$BOBSHELL_INSTALL_ROOT$HOME/.cache}}"
	: "${BOBSHELL_INSTALL_USER_SYSTEMDDIR=${BOBSHELL_INSTALL_SYSTEMDDIR-$BOBSHELL_INSTALL_ROOT$HOME/.config/systemd/user}}"
	: "${BOBSHELL_INSTALL_USER_PROFILE=${BOBSHELL_INSTALL_PROFILE-$BOBSHELL_INSTALL_ROOT$HOME/.profile}}"

	if [ -z "${BOBSHELL_INSTALL_ROLE:-}" ]; then
		if bobshell_is_root; then
			BOBSHELL_INSTALL_ROLE=SYSTEM
		else
			BOBSHELL_INSTALL_ROLE=USER
		fi
	fi


	if [ SYSTEM = "$BOBSHELL_INSTALL_ROLE" ]; then
		BOBSHELL_INSTALL_BINDIR="$BOBSHELL_INSTALL_SYSTEM_BINDIR"
		BOBSHELL_INSTALL_CONFDIR="$BOBSHELL_INSTALL_SYSTEM_CONFDIR"
		BOBSHELL_INSTALL_DATADIR="$BOBSHELL_INSTALL_SYSTEM_DATADIR"
		BOBSHELL_INSTALL_LOCALSTATEDIR="$BOBSHELL_INSTALL_SYSTEM_LOCALSTATEDIR"
		BOBSHELL_INSTALL_CACHEDIR="$BOBSHELL_INSTALL_SYSTEM_CACHEDIR"
		BOBSHELL_INSTALL_SYSTEMDDIR="$BOBSHELL_INSTALL_SYSTEM_SYSTEMDDIR"
		BOBSHELL_INSTALL_PROFILE="$BOBSHELL_INSTALL_SYSTEM_PROFILE"
	else
		BOBSHELL_INSTALL_BINDIR="$BOBSHELL_INSTALL_USER_BINDIR"
		BOBSHELL_INSTALL_CONFDIR="$BOBSHELL_INSTALL_USER_CONFDIR"
		BOBSHELL_INSTALL_DATADIR="$BOBSHELL_INSTALL_USER_DATADIR"
		BOBSHELL_INSTALL_LOCALSTATEDIR="$BOBSHELL_INSTALL_USER_LOCALSTATEDIR"
		BOBSHELL_INSTALL_CACHEDIR="$BOBSHELL_INSTALL_USER_CACHEDIR"
		BOBSHELL_INSTALL_SYSTEMDDIR="$BOBSHELL_INSTALL_USER_SYSTEMDDIR"
		BOBSHELL_INSTALL_PROFILE="$BOBSHELL_INSTALL_USER_PROFILE"
	fi

		
	: "${BOBSHELL_INSTALL_SYSTEMCTL:=systemctl}"
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








# fun: bobshell_install_put SRC DIR DESTNAME MODE
bobshell_install_put() {
	mkdir -p "$BOBSHELL_INSTALL_DESTDIR$2"
	bobshell_copy "$1" "file:$BOBSHELL_INSTALL_DESTDIR$2/$3"
	chmod "$4" "$BOBSHELL_INSTALL_DESTDIR$2/$3"
}

# fun: bobshell_install_binary SRC DESTNAME
# use: bobshell_install_binary target/exesrc.sh mysuperprog
bobshell_install_put_executable() {
	bobshell_install_put "$1" "$BOBSHELL_INSTALL_BINDIR" "$2" u=rwx,go=rx
}

bobshell_install_put_config() {
	bobshell_install_put "$1" "$BOBSHELL_INSTALL_CONFDIR/$BOBSHELL_INSTALL_NAME" "$2" u=rw,go=r
}

bobshell_install_put_data() {
	bobshell_install_put "$1" "$BOBSHELL_INSTALL_DATADIR/$BOBSHELL_INSTALL_NAME" "$2" u=rw,go=r
}

bobshell_install_put_localstate() {
	bobshell_install_put "$1" "$BOBSHELL_INSTALL_LOCALSTATEDIR/$BOBSHELL_INSTALL_NAME" "$2" u=rw,go=r
}

bobshell_install_put_cache() {
	bobshell_install_put "$1" "$BOBSHELL_INSTALL_CACHEDIR/$BOBSHELL_INSTALL_NAME" "$2" u=rw,go=r
}









# fun: bobshell_install_find SYSTEMCANDIDATE USERCANDIDATE
bobshell_install_find() {
	if bobshell_is_not_root && [ -f "$BOBSHELL_INSTALL_DESTDIR$2" ]; then
		printf %s "$2"
		return
	fi

	if [ -f "$BOBSHELL_INSTALL_DESTDIR$1" ]; then
		printf %s "$1"
		return
	fi

	return 1
}

bobshell_install_find_executable() {
	bobshell_install_find "$BOBSHELL_INSTALL_SYSTEM_BINDIR/$1" "$BOBSHELL_INSTALL_USER_BINDIR/$1"
}

bobshell_install_find_config() {
	bobshell_install_find "$BOBSHELL_INSTALL_SYSTEM_CONFDIR/$BOBSHELL_INSTALL_NAME/$1" "$BOBSHELL_INSTALL_USER_CONFDIR/$BOBSHELL_INSTALL_NAME/$1"
}

bobshell_install_find_data() {
	bobshell_install_find "$BOBSHELL_INSTALL_SYSTEM_DATADIR/$BOBSHELL_INSTALL_NAME/$1" "$BOBSHELL_INSTALL_USER_DATADIR/$BOBSHELL_INSTALL_NAME/$1"
}

bobshell_install_find_localstate() {
	bobshell_install_find "$BOBSHELL_INSTALL_SYSTEM_LOCALSTATEDIR/$BOBSHELL_INSTALL_NAME/$1" "$BOBSHELL_INSTALL_USER_LOCALSTATEDIR/$BOBSHELL_INSTALL_NAME/$1"
}

bobshell_install_find_cache() {
	bobshell_install_find "$BOBSHELL_INSTALL_SYSTEM_CACHEDIR/$BOBSHELL_INSTALL_NAME/$1" "$BOBSHELL_INSTALL_USER_CACHEDIR/$BOBSHELL_INSTALL_NAME/$1"
}

















# fun: bobshell_install_get FUN NAME DEST
bobshell_install_get() {
	bobshell_install_get_dest="$3"
	set -- "$1" "$2"
	if bobshell_install_get_found=$("$@"); then
		bobshell_copy "file:$bobshell_install_get_found" "$bobshell_install_get_dest"
		return
	else
		return 1
	fi
}

# fun: bobshell_install_get_executable NAME DEST
bobshell_install_get_executable() {
	bobshell_install_get bobshell_install_find_executable "$1" "$2"
}

# fun: bobshell_install_get_config NAME DEST
bobshell_install_get_config() {
	bobshell_install_get bobshell_install_find_config "$1" "$2"
}

bobshell_install_get_data() {
	bobshell_install_get bobshell_install_find_data "$1" "$2"
}

bobshell_install_get_localstate() {
	bobshell_install_get bobshell_install_find_localstate "$1" "$2"
}

bobshell_install_get_cache() {
	bobshell_install_get bobshell_install_find_cache "$1" "$2"
}


