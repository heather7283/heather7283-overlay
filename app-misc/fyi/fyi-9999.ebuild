EAPI=8

inherit meson

DESCRIPTION="notify-send alternative"
HOMEPAGE="https://codeberg.org/dnkl/fyi"

inherit git-r3
EGIT_REPO_URI="https://codeberg.org/dnkl/fyi.git"

LICENSE="MIT"
SLOT="0"

RDEPEND="
	sys-apps/dbus
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
    dev-build/ninja
    dev-build/meson
"

src_install() {
	local DOCS=( CHANGELOG.md README.md )
	meson_src_install

	rm -r "${ED}"/usr/share/doc/"${PN}" || die
}
