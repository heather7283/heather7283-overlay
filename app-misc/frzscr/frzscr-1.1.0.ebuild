EAPI=8

inherit meson

DESCRIPTION="Screen freezing program for wayland"
HOMEPAGE="https://github.com/heather7283/frzscr"

if [[ ${PV} = 9999 ]]; then
	EGIT_REPO_URI="https://github.com/heather7283/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/heather7283/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	dev-libs/wayland
"
DEPEND="
	${RDEPEND}
    dev-libs/wayland-protocols
"
BDEPEND="
	dev-util/wayland-scanner
"

