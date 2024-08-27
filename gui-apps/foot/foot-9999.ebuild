EAPI=8

inherit meson xdg

DESCRIPTION="Fast, lightweight and minimalistic Wayland terminal emulator"
HOMEPAGE="https://codeberg.org/dnkl/foot"

inherit git-r3
EGIT_REPO_URI="https://codeberg.org/dnkl/foot.git"

LICENSE="MIT"
SLOT="0"
IUSE="+grapheme-clustering +ime +terminfo themes pgo test"
RESTRICT="!test? ( test )"

COMMON_DEPEND="
	dev-libs/wayland
	media-libs/fcft
	media-libs/fontconfig
	x11-libs/libxkbcommon
	x11-libs/pixman
	grapheme-clustering? (
		dev-libs/libutf8proc:=
		media-libs/fcft[harfbuzz]
	)
    pgo? (
        >=gui-wm/sway-1.7
    )
"
DEPEND="
	${COMMON_DEPEND}
	>=dev-libs/tllist-1.1.0
	>=dev-libs/wayland-protocols-1.32
"
RDEPEND="
	${COMMON_DEPEND}
    >=sys-libs/ncurses-6.3[-minimal]
"
BDEPEND="
	app-text/scdoc
	dev-util/wayland-scanner
"

BUILD_DIR="${S}/build"

src_prepare() {
	default
	# disable the systemd dep, we install the unit file manually
	sed -i "s/systemd', required: false)$/', required: false)/" "${S}"/meson.build || die
}

src_configure() {
	local emesonargs=(
		$(meson_feature grapheme-clustering)
		$(meson_use test tests)
        $(meson_use ime)
        $(meson_feature terminfo)
        $(meson_use themes)
	)
	meson_src_configure -Ddefault-terminfo=foot -Dterminfo-base-name=foot-extra
}

src_compile() {
    if use pgo; then
        ./pgo/pgo.sh full-headless-sway "${S}" "${BUILD_DIR}" \
            --prefix=/usr \
            --wrap-mode=nodownload || die
    else
        meson_src_compile
    fi
}

src_install() {
	local DOCS=( CHANGELOG.md README.md LICENSE )
	meson_src_install

	# foot unconditionally installs CHANGELOG.md, README.md and LICENSE.
	# we handle this via DOCS and dodoc instead.
	rm -rv "${ED}/usr/share/doc/${PN}" || die
}
