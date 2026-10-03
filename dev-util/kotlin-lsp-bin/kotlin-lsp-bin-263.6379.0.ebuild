EAPI=8

case "$ARCH" in
    (amd64) ARCH_SUFFIX='' ;;
    (arm64) ARCH_SUFFIX='-aarch64' ;;
esac
BASE_NAME="kotlin-server-${PV}"

DESCRIPTION="Kotlin Language Server"
HOMEPAGE="https://github.com/Kotlin/kotlin-lsp"
SRC_URI="https://download-cdn.jetbrains.com/language-server/kotlin-server/${PV}/${BASE_NAME}${ARCH_SUFFIX}.tar.gz -> ${P}.tar.gz"
S="$WORKDIR"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

QA_PREBUILT="*"

src_install() {
    mkdir "${ED}/opt" || die
    cp -a "$BASE_NAME" "${ED}/opt/" || die
    dosym "../${BASE_NAME}/bin/intellij-server" /opt/bin/kotlin-lsp
}

