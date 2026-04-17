EAPI=8

inherit go-module

DESCRIPTION="Declarative CLI transcoding tool"
HOMEPAGE="https://github.com/heather7283/estrogen"
SRC_URI="
    https://github.com/heather7283/estrogen/archive/refs/tags/v${PV}.tar.gz
    https://github.com/heather7283/estrogen/releases/download/v${PV}/estrogen-${PV}-vendor.tar.xz
"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

src_compile() {
    ego build
}

src_install() {
    dobin estrogen
    default
}

