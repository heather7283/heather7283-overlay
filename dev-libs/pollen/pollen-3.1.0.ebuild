EAPI=8

inherit meson

DESCRIPTION="Single header event loop abstraction library built on epoll"
HOMEPAGE="https://github.com/heather7283/pollen"

if [[ ${PV} = *9999 ]]; then
	EGIT_REPO_URI="https://github.com/heather7283/pollen.git"
	inherit git-r3
else
	SRC_URI="https://github.com/heather7283/pollen/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/pollen-${PV}"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

src_configure() {
    local emesonargs=(
        $(meson_use test)
    )
    meson_src_configure
}

