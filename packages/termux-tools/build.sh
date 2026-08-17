TERMUX_PKG_HOMEPAGE=https://termux.dev/
TERMUX_PKG_DESCRIPTION="Basic system tools for Termux"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.46.0+really1.45.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/termux/termux-tools/archive/refs/tags/v1.45.0.tar.gz
TERMUX_PKG_SHA256=1ae29b1b875d95cc626dae323b45a2ace759969862d96094b2fa6d13bffe20d2
TERMUX_PKG_ESSENTIAL=true
#TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_BREAKS="termux-keyring (<< 1.9)"
TERMUX_PKG_CONFLICTS="procps (<< 3.3.15-2)"
TERMUX_PKG_SUGGESTS="termux-api"

# Some of these packages are not dependencies and used only to ensure
# that core packages are installed after upgrading (we removed busybox
# from essentials).
TERMUX_PKG_DEPENDS="bzip2, coreutils, curl, dash, diffutils, findutils, gawk, grep, gzip, less, procps, psmisc, sed, tar, termux-am (>= 0.8.0), termux-am-socket (>= 1.5.0), termux-core, termux-exec, util-linux, xz-utils, dialog"

# Optional packages that are distributed as part of bootstrap archives.
TERMUX_PKG_RECOMMENDS="ed, dos2unix, inetutils, net-tools, patch, unzip"

termux_step_pre_configure() {
	autoreconf -vfi
}

termux_step_post_make_install() {
	TERMUX_PKG_CONFFILES="$(cat "$TERMUX_PKG_BUILDDIR/conffiles")"

	# Keep DroidShell installs on the fork's repository. The upstream pkg
	# script selects a Termux mirror whenever an install/update command runs,
	# which would overwrite the custom prefix repository.
	if [ "$TERMUX_APP_PACKAGE" = "com.droidshell.app" ]; then
		local pkg_script="$TERMUX_PREFIX/bin/pkg"
		local tmp_script="$TERMUX_PKG_TMPDIR/pkg.droidshell"
		awk '
			/^select_mirror\(\) \{/ {
				print
				print "\tif [ -f \"/data/data/com.droidshell.app/files/usr/etc/termux/droidshell-repo\" ]; then"
				print "\t\techo \"deb [trusted=yes] https://codedev-404.github.io/termux-packages/apt/termux-droidshell ./\" > \"/data/data/com.droidshell.app/files/usr/etc/apt/sources.list\""
				print "\t\treturn 0"
				print "\tfi"
				next
			}
			{ print }
		' "$pkg_script" > "$tmp_script"
		install -m 755 "$tmp_script" "$pkg_script"
	fi
}

termux_step_create_debscripts() {
	cat <<- EOF > ./preinst
	$(cat "$TERMUX_PKG_BUILDDIR/preinst")
	EOF
}
