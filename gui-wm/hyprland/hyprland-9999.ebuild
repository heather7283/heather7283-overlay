EAPI=8

inherit cmake toolchain-funcs

DESCRIPTION="A dynamic tiling Wayland compositor that doesn't sacrifice on its looks"
HOMEPAGE="https://github.com/hyprwm/Hyprland"

if [[ "${PV}" = *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/hyprwm/${PN^}.git"
else
	SRC_URI="https://github.com/hyprwm/${PN^}/releases/download/v${PV}/source-v${PV}.tar.gz -> ${P}.gh.tar.gz"
	S="${WORKDIR}/${PN}-source"

	KEYWORDS="~amd64"
fi

LICENSE="BSD"
SLOT="0"
IUSE="X systemd uwsm hyprpm test"

# hyprpm (hyprland plugin manager) requires the dependencies at runtime
# so that it can clone, compile and install plugins.
HYPRPM_RDEPEND="
	hyprpm? (
		app-alternatives/ninja
		>=dev-build/cmake-3.30
		dev-build/meson
		dev-vcs/git
		virtual/pkgconfig
	)
"
RDEPEND="
	${HYPRPM_RDEPEND}

	>=gui-libs/aquamarine-0.9.3
	>=dev-libs/hyprlang-0.6.7
	>=gui-libs/hyprcursor-0.1.7
	>=gui-libs/hyprutils-0.11.0
	>=dev-libs/hyprgraphics-0.1.6

	>=x11-libs/libxkbcommon-1.11.0
	>=dev-libs/wayland-1.22.90

	dev-cpp/tomlplusplus
	dev-libs/glib:2
	>=dev-libs/libinput-1.28
	dev-libs/re2:=
	>=dev-libs/udis86-1.7.2
	media-libs/libglvnd
	media-libs/mesa
	sys-apps/util-linux
	x11-libs/cairo
	x11-libs/libdrm
	x11-libs/pango
	x11-libs/pixman
	x11-libs/libXcursor
    dev-cpp/muParser

	X? (
		x11-libs/libxcb:0=
		x11-base/xwayland
		x11-libs/xcb-util-errors
		x11-libs/xcb-util-wm
	)
"
DEPEND="
	${RDEPEND}
	dev-cpp/glaze
	>=dev-libs/hyprland-protocols-0.6.0
	>=dev-libs/wayland-protocols-1.45
"
BDEPEND="
	|| ( >=sys-devel/gcc-15:* >=llvm-core/clang-18:* )
	app-misc/jq
	dev-build/cmake
	>=dev-util/hyprwayland-scanner-0.3.10
	virtual/pkgconfig
    test? ( dev-cpp/gtest )
"

pkg_setup() {
	[[ ${MERGE_TYPE} == binary ]] && return

	if tc-is-gcc && ver_test $(gcc-version) -lt 15 ; then
		eerror "Hyprland requires >=sys-devel/gcc-15 to build"
		eerror "Please upgrade GCC: emerge -v1 sys-devel/gcc"
		die "GCC version is too old to compile Hyprland!"
	elif tc-is-clang && ver_test $(clang-version) -lt 18 ; then
		eerror "Hyprland requires >=llvm-core/clang-18 to build"
		eerror "Please upgrade Clang: emerge -v1 llvm-core/clang"
		die "Clang version is too old to compile Hyprland!"
	fi
}

src_configure() {
	local mycmakeargs=(
        -DNO_XWAYLAND=$(usex X no yes)
        -DNO_SYSTEMD=$(usex systemd no yes)
        -DNO_UWSM=$(usex uwsm no yes)
        -DNO_HYPRPM=$(usex hyprpm no yes)
        -DBUILD_TESTING=$(usex test)
	)

	cmake_src_configure
}
