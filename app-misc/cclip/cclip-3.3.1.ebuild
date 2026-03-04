EAPI=8

inherit meson

DESCRIPTION="Clipboard manager for wayland"
HOMEPAGE="https://github.com/heather7283/cclip"

if [[ ${PV} == 9999 ]]; then
    inherit git-r3
    EGIT_REPO_URI="https://github.com/heather7283/cclip.git"
else
    SRC_URI="https://github.com/heather7283/cclip/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
    KEYWORDS="~amd64"
fi

LICENSE="GPL-3+"
SLOT="0"
IUSE="man"

RDEPEND="
	dev-db/sqlite
	dev-libs/wayland
	dev-libs/xxhash
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
    dev-build/ninja
    dev-build/meson
	dev-util/wayland-scanner
"

src_configure() {
	local emesonargs=(
		$(meson_use man)
	)
	meson_src_configure
}

