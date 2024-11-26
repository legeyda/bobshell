
shelduck import string.sh
shelduck import scope.sh
shelduck import util.sh
shelduck import locator.sh


# env: BOBSHELL_INSTALL_NAME
bobshell_install_init() {
	# https://www.gnu.org/prep/standards/html_node/Directory-Variables.html#Directory-Variables
	
	: "${BOBSHELL_INSTALL_DESTDIR:=}"

	: "${BOBSHELL_INSTALL_ROOT_PREFIX:=/opt}"
	: "${BOBSHELL_INSTALL_ROOT_BINDIR:=$BOBSHELL_INSTALL_ROOT_PREFIX/bin}"
	: "${BOBSHELL_INSTALL_ROOT_CONFDIR:=$BOBSHELL_INSTALL_ROOT_PREFIX/etc}"
	: "${BOBSHELL_INSTALL_ROOT_DATADIR:=$BOBSHELL_INSTALL_ROOT_PREFIX/share}"
	: "${BOBSHELL_INSTALL_ROOT_LOCALSTATEDIR:=$BOBSHELL_INSTALL_ROOT_PREFIX/var}"
	: "${BOBSHELL_INSTALL_ROOT_CACHEDIR:=/var/opt/cache}"
	: "${BOBSHELL_INSTALL_ROOT_SYSTEMDDIR:=/etc/systemd/system}"
	: "${BOBSHELL_INSTALL_ROOT_PROFILE:=/etc/profile}"

	: "${BOBSHELL_INSTALL_USER_PREFIX:=$HOME/.local}"
	: "${BOBSHELL_INSTALL_USER_BINDIR:=$BOBSHELL_INSTALL_USER_PREFIX/bin}"
	: "${BOBSHELL_INSTALL_USER_CONFDIR:=$HOME/.config}"
	: "${BOBSHELL_INSTALL_USER_DATADIR:=$BOBSHELL_INSTALL_USER_PREFIX/share}"
	: "${BOBSHELL_INSTALL_USER_LOCALSTATEDIR:=$BOBSHELL_INSTALL_USER_PREFIX/var}"
	: "${BOBSHELL_INSTALL_USER_CACHEDIR:=$HOME/.cache}"
	: "${BOBSHELL_INSTALL_USER_SYSTEMDDIR:=$HOME/.config/systemd/user}"
	: "${BOBSHELL_INSTALL_USER_PROFILE:=$HOME/.profile}"



	# if [ 0 = "$(id -u)" ]; then
	# 	bobshell_scope_copy BOBSHELL_INSTALL_ROOT_ BOBSHELL_INSTALL_
	# else
	# 	bobshell_scope_copy BOBSHELL_INSTALL_USER_ BOBSHELL_INSTALL_
	# fi



	: "${BOBSHELL_INSTALL_SYSTEMCTL:=systemctl}"

}





# fun: bobshell_install_service SRCLOCATOR DESTNAME
# use: bobshell_install_service file:target/myservice myservice.service
bobshell_install_service() {

	if [ 0 = "$(id -u)" ]; then
		bobshell_install_service_dir="$BOBSHELL_INSTALL_DESTDIR$BOBSHELL_INSTALL_ROOT_SYSTEMDDIR"
		bobshell_install_service_arg=
	else
		bobshell_install_service_dir="$BOBSHELL_INSTALL_DESTDIR$BOBSHELL_INSTALL_USER_SYSTEMDDIR"
		bobshell_install_service_arg='--user'
	fi

	mkdir -p "$bobshell_install_service_dir"
	bobshell_copy "$1" "file:$bobshell_install_service_dir/$2"

	
	$BOBSHELL_INSTALL_SYSTEMCTL $bobshell_install_service_arg daemon-reload
	$BOBSHELL_INSTALL_SYSTEMCTL $bobshell_install_service_arg enable "$2"
}










# fun: bobshell_install_find_root_dir TYPE
bobshell_install_getvar() {
	if bobshell_is_root; then
		bobshell_install_root_getvar "$@"
	else
		bobshell_install_user_getvar "$@"
	fi
}

# fun: bobshell_install_find_dir TYPE
bobshell_install_root_getvar() {
	bobshell_getvar "BOBSHELL_INSTALL_ROOT_$1"
}

# fun: bobshell_install_user_getvar TYPE
bobshell_install_user_getvar() {
	bobshell_getvar "BOBSHELL_INSTALL_USER_$1"
}




# fun: bobshell_install_binary SRC DESTNAME
# use: bobshell_install_binary target/exesrc.sh mysuperprog
bobshell_install_put_executable() {
	bobshell_install_put_executable_dir=$(bobshell_install_getvar BINDIR)
	mkdir -p "$BOBSHELL_INSTALL_DESTDIR$bobshell_install_put_executable_dir"
	bobshell_install_put_executable_file="$bobshell_install_put_executable_dir/$2"
	bobshell_copy "$1" "file:$BOBSHELL_INSTALL_DESTDIR$bobshell_install_put_executable_dir/$2" "$BOBSHELL_INSTALL_DESTDIR$bobshell_install_put_executable_file"
}

# fun: bobshell_install_put TYPE SRC DESTNAME
bobshell_install_put() {
	bobshell_install_put_dir=$(bobshell_install_getvar "$1")
	mkdir -p "$BOBSHELL_INSTALL_DESTDIR$bobshell_install_put_dir/$BOBSHELL_INSTALL_NAME"
	bobshell_install_put_file="$bobshell_install_put_dir/$BOBSHELL_INSTALL_NAME/$3"
	bobshell_copy "$2" "file:$bobshell_install_put_file"
	chmod u=rw,go=r "$bobshell_install_put_file"
}

bobshell_install_put_config() {
	bobshell_install_put CONFDIR "$@"
}

bobshell_install_put_data() {
	bobshell_install_put DATADIR "$@"
}

bobshell_install_put_localstate() {
	bobshell_install_put LOCALSTATEDIR "$@"
}

bobshell_install_put_cache() {
	bobshell_install_put CACHEDIR "$@"
}






# bobshell_install_get TYPE NAME
bobshell_install_find() {
	if bobshell_is_not_root && bobshell_install_user_find "$@"; then
		return
	fi

	if bobshell_install_root_find "$@"; then
		return
	fi

	return 1
}


bobshell_install_root_find() {
	bobshell_install_root_find_dir=$(bobshell_install_root_getvar "$1")
	bobshell_install_root_find_file="$bobshell_install_root_find_dir/$BOBSHELL_INSTALL_NAME/$2"
	if [ ! -f "$bobshell_install_root_find_file" ]; then
		return 1
	fi
	printf %s "$bobshell_install_root_find_file"
}

bobshell_install_user_find() {
	bobshell_install_user_find_dir=$(bobshell_install_root_getvar "$1")
	bobshell_install_user_find_file="$bobshell_install_user_find_dir/$BOBSHELL_INSTALL_NAME/$2"
	if [ ! -f "$bobshell_install_user_find_file" ]; then
		return 1
	fi
	printf %s "$bobshell_install_user_find_file"
}



# fun: bobshell_install_get TYPE NAME DEST
bobshell_install_get() {
	if ! bobshell_install_get_found=$(bobshell_install_find "$1" "$2"); then
		return 1
	fi
	bobshell_copy "file:$bobshell_install_get_found" "$3"
}




# fun: bobshell_install_get_config app.conf
bobshell_install_get_config() {
	bobshell_install_get CONFDIR "$@"
}

bobshell_install_get_data() {
	bobshell_install_get DATADIR "$@"
}

bobshell_install_get_localstate() {
	bobshell_install_get LOCALSTATEDIR "$@"
}

bobshell_install_get_cache() {
	bobshell_install_get CACHE "$@"
}


