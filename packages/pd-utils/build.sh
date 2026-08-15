TERMUX_PKG_HOMEPAGE=https://github.com/CodeDev-404/termux-packages
TERMUX_PKG_DESCRIPTION="Personal utilities for the user: backups, device health and notifications"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@CodeDev-404"
TERMUX_PKG_VERSION=1.0.0
TERMUX_PKG_PLATFORM_INDEPENDENT=true
# Source lives inside the package directory (no external download).
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_DEPENDS="bash"

termux_step_make_install() {
	install -Dm700 "$TERMUX_PKG_BUILDER_DIR/pd-backup" "$TERMUX_PREFIX/bin/pd-backup"
	install -Dm700 "$TERMUX_PKG_BUILDER_DIR/pd-restore" "$TERMUX_PREFIX/bin/pd-restore"
	install -Dm700 "$TERMUX_PKG_BUILDER_DIR/pd-health" "$TERMUX_PREFIX/bin/pd-health"
}
