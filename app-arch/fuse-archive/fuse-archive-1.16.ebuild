EAPI=8

inherit toolchain-funcs optfeature

DESCRIPTION="Read-only FUSE file system for mounting archives and compressed files"
HOMEPAGE="https://github.com/google/fuse-archive"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/google/${PN}.git"
	inherit git-r3
else
    SRC_URI="https://github.com/google/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="Apache-2.0"
SLOT="0"
IUSE="fuse2"

DEPEND="
	fuse2? ( >=sys-fs/fuse-2.9:0 )
	!fuse2? ( >=sys-fs/fuse-3.1:3 )
	>=app-arch/libarchive-3.7
"
BDEPEND="virtual/pkgconfig"
RDEPEND="${DEPEND}"
# TODO(NRK): enable tests. requires python + a lot of format support.
# also takes a lot of disk space (and time) by generating big.zip.
RESTRICT="test"

src_configure() {
	sed -i 's|-O2||g' Makefile || die "sed failed"
	sed -i 's|-O0 -g||g' Makefile || die "sed failed"
}

src_compile() {
	emake CXX="$(tc-getCXX)" PKG_CONFIG="$(tc-getPKG_CONFIG)" FUSE_MAJOR_VERSION="$(usex fuse2 2 3)"
}

src_install() {
	dobin out/fuse-archive
	doman fuse-archive.1
}

pkg_postinst() {
	optfeature "mounting brotli compressed files" "app-arch/brotli"
	optfeature "mounting LZO compressed files" "app-arch/lzop"
	optfeature "mounting compress (.Z) files" "app-arch/ncompress"
}

