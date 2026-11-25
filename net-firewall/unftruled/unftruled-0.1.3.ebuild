EAPI=8

inherit go-module

DESCRIPTION="NFT rules manager for systemd user services"
HOMEPAGE="https://github.com/heather7283/unftruled"
SRC_URI="
    https://github.com/heather7283/unftruled/archive/refs/tags/v${PV}.tar.gz
    https://github.com/heather7283/unftruled/releases/download/v${PV}/unftruled-${PV}-vendor.tar.xz
"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

src_compile() {
	emake DESTDIR="${D}" PREFIX=/usr
}

src_install() {
	emake DESTDIR="${D}" PREFIX=/usr install
	dodoc assets/example.toml
}

