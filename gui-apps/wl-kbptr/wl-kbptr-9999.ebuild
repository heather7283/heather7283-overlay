EAPI=8

inherit meson

DESCRIPTION="Control the mouse pointer with the keyboard on Wayland"
HOMEPAGE="https://github.com/heather7283/pollen"

if [[ ${PV} = 9999 ]]; then
	EGIT_REPO_URI="https://github.com/moverest/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/moverest/${PN}/archive/refs/tags/v${PV}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="-opencv"

RDEPEND="
    dev-libs/wayland
    x11-libs/libxkbcommon
    x11-libs/cairo
    opencv? (
        media-libs/opencv
        x11-libs/pixman
    )
"
DEPEND="
    ${RDEPEND}
    dev-libs/wayland-protocols
"
BDEPEND="
    dev-util/wayland-scanner
"

src_configure() {
    local emesonargs=(
        $(meson_feature opencv)
    )
    meson_src_configure
}

