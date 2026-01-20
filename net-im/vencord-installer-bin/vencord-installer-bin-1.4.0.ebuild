EAPI=8

DESCRIPTION="A CLI app for installing Vencord"
HOMEPAGE="https://github.com/Vencord/Installer"
SRC_URI="https://github.com/Vencord/Installer/releases/download/v${PV}/VencordInstallerCli-linux"
S="${WORKDIR}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

src_unpack() {
    : # no-op
}

src_install() {
    dobin "${DISTDIR}/VencordInstallerCli-linux"
}

