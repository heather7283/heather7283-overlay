EAPI=8

inherit meson systemd xdg git-r3

DESCRIPTION="Fast, lightweight and minimalistic Wayland terminal emulator"
HOMEPAGE="https://codeberg.org/dnkl/foot"
EGIT_REPO_URI="https://codeberg.org/dnkl/foot.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE="+grapheme-clustering test utempter"
RESTRICT="!test? ( test )"

COMMON_DEPEND="
	dev-libs/wayland
	>=media-libs/fcft-3.3.1
	media-libs/fontconfig
	x11-libs/libxkbcommon
	x11-libs/pixman
	grapheme-clustering? (
		dev-libs/libutf8proc:=[-cjk]
		media-libs/fcft[harfbuzz]
	)
"
DEPEND="
	${COMMON_DEPEND}
	>=dev-libs/tllist-1.1.0
	>=dev-libs/wayland-protocols-1.41
"
RDEPEND="
	${COMMON_DEPEND}
	|| (
		~gui-apps/foot-terminfo-${PV}
		>=sys-libs/ncurses-6.3[-minimal]
	)
	utempter? ( sys-libs/libutempter )
"
BDEPEND="
	app-text/scdoc
	dev-util/wayland-scanner
"

src_prepare() {
	default

	# disable the systemd dep, we install the unit file manually
	sed -i "s/systemd', required: false)$/', required: false)/" meson.build || die

	# adjust install dir
	sed -i "s/'doc', 'foot'/'doc', '${PF}'/" meson.build || die

	# do not install LICENSE file
	sed -i "s/'LICENSE', //" meson.build || die
}

src_configure() {
	local emesonargs=(
		-Ddocs=enabled
		-Dthemes=true
		-Dime=true
		-Dterminfo=disabled
		$(meson_feature grapheme-clustering)
		$(meson_use test tests)
		-Dutmp-backend=$(usex utempter libutempter none)
		-Dutmp-default-helper-path="/usr/$(get_libdir)/misc/utempter/utempter"
	)
	meson_src_configure

	sed 's|@bindir@|/usr/bin|g' "${S}"/foot-server.service.in > foot-server.service || die
}

src_install() {
	meson_src_install

	systemd_douserunit foot-server.service "${S}"/foot-server.socket
}

pkg_postinst() {
	xdg_pkg_postinst
}
