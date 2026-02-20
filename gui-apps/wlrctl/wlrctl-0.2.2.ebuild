EAPI=8

inherit meson

DESCRIPTION="Utility for miscellaneous wlroots extensions"
HOMEPAGE="https://git.sr.ht/~brocellous/wlrctl"

if [[ ${PV} = 9999 ]]; then
	EGIT_REPO_URI="https://git.sr.ht/~brocellous/${PN}"
	inherit git-r3
else
	SRC_URI="https://git.sr.ht/~brocellous/${PN}/archive/v${PV}.tar.gz"
    S="${WORKDIR}/${PN}-v${PV}"
	KEYWORDS="~amd64"
fi

LICENSE="MIT"
SLOT="0"
IUSE="man"

DEPEND="
    dev-libs/wayland
    x11-libs/libxkbcommon
"
RDEPEND="
    ${DEPEND}
"
BDEPEND="
    man? (
        app-text/scdoc
    )
"

src_configure() {
    local emesonargs=(
        $(meson_feature man man-pages)
    )
    meson_src_configure
}

