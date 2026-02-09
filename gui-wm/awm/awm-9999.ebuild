EAPI=8

inherit meson

DESCRIPTION="Anime Window Manager"
HOMEPAGE="https://github.com/dy-tea/awm"

if [[ "${PV}" = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/dy-tea/${PN}.git"
    EGIT_SUBMODULES=()
else
	SRC_URI="https://github.com/dy-tea/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-3+"
SLOT="0"
# TODO: add test and stacktrace USE
IUSE="X systemd"

# TODO: add backward-cpp
RDEPEND="
    dev-libs/wayland
    x11-libs/pixman
    x11-libs/libxkbcommon
    dev-libs/libinput
    gui-libs/wlroots:0.20
    dev-cpp/nlohmann_json

    X? (
        x11-base/xwayland
        x11-misc/xcb
    )
"
# TODO: add test deps
DEPEND="
    ${RDEPEND}
"
BDEPEND="
    dev-util/wayland-scanner
"

src_configure() {
    # TODO: add test arg, add backward-cpp
    local emesonargs=(
        $(meson_use X XWAYLAND)
        $(meson_use systemd SYSTEMD)
    )
    meson_src_configure
}

