EAPI=8

inherit meson

DESCRIPTION="Wayland compositor based on bswpm"
HOMEPAGE="https://github.com/dy-tea/bwm"

inherit git-r3
EGIT_REPO_URI="https://github.com/dy-tea/${PN}.git"

LICENSE="GPL-3"
SLOT="0"
IUSE=""

RDEPEND="
    =gui-libs/wlroots-9999
    dev-libs/wayland
    x11-libs/libxkbcommon
    dev-libs/libinput
    x11-libs/pixman

    x11-libs/libxcb
    x11-libs/xcb-util-wm
    x11-base/xwayland
"
DEPEND="
    dev-libs/wayland-protocols
    ${RDEPEND}
"
BDEPEND="
    dev-util/wayland-scanner
"

src_install() {
    meson_src_install

    dodoc README.md
    docinto examples
    dodoc examples/{README.md,bwm{,hk}rc}
}

