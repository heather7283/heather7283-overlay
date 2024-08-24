EAPI=8

DESCRIPTION="Bypass deep packet inspection"
HOMEPAGE="https://github.com/bol-van/zapret"

inherit git-r3
EGIT_REPO_URI="https://github.com/bol-van/zapret.git"

LICENSE="MIT"

SLOT="0"

IUSE="+tpws nfqws ip2net mdig"
REQUIRED_USE="|| ( tpws nfqws ip2net mdig )"

RDEPEND="
    tpws? (
        sys-libs/zlib
    )
    nfqws? (
        sys-libs/zlib
        net-libs/libmnl
        net-libs/libnfnetlink
        net-libs/libnetfilter_queue
    )
"
DEPEND="${RDEPEND}"

src_configure() {
    true
}

src_compile() {
    # hack to only build desired binaries
    use tpws && export DIRS="tpws"
    use nfqws && export DIRS="nfq ${DIRS}"
    use ip2net && export DIRS="ip2net ${DIRS}"
    use mdig && export DIRS="mdig ${DIRS}"

    # hack to put built binaries into build directory
    mkdir -v "${S}/build" || die
    export TGT="${S}/build"

    emake -e

    unset DIRS TGT
}

src_install() {
    install -v -m755 -o root -g root -Dt "${D}"/usr/bin/ "${S}"/build/*
}
