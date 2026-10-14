EAPI=8

DESCRIPTION="Xorg DDX driver for ARM devices"
HOMEPAGE="https://github.com/ssvb/xf86-video-fbturbo"
SRC_URI="https://github.com/ssvb/xf86-video-fbturbo/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

# https://github.com/ssvb/xf86-video-fbturbo/blob/master/COPYING makes no sense
LICENSE="GPL-2 MIT"
SLOT="0"
KEYWORDS="~arm"

RDEPEND="
	x11-base/xorg-server:=
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"

PATCHES=(
	# see https://github.com/ssvb/xf86-video-fbturbo/pull/59
	"${FILESDIR}/${P}-backports-from-xf86-video-fbdev.patch"
)

src_install() {
	default
	find "${ED}" -name '*.la' -delete
}

