EAPI=8

inherit meson

DESCRIPTION="TUI volume control app for pipewire"
HOMEPAGE="https://github.com/heather7283/pipemixer"

if [[ ${PV} = 9999 ]]; then
    inherit git-r3
    EGIT_REPO_URI="https://github.com/heather7283/${PN}.git"
else
    SRC_URI="https://github.com/heather7283/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
    KEYWORDS="~amd64"
fi

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
    sys-libs/ncurses
    media-video/pipewire
    dev-libs/inih
"
DEPEND="
    ${RDEPEND}
"

