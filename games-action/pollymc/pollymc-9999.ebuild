# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake java-pkg-2 optfeature xdg

HOMEPAGE="https://github.com/fn2006/PollyMC"
DESCRIPTION="DRM-free Prism Launcher fork"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3

	EGIT_REPO_URI="
		https://github.com/fn2006/PollyMC
	"

	EGIT_SUBMODULES=( 'depends/libnbtplusplus' )
fi

# Apache-2.0 for MultiMC (PolyMC is forked from it)
# GPL-3 for PolyMC
# LGPL-3+ for libnbtplusplus
# See the rest of PolyMC's libraries at https://github.com/PolyMC/PolyMC/tree/develop/libraries
LICENSE="Apache-2.0 BSD BSD-2 GPL-2+ GPL-3 ISC LGPL-2.1+ LGPL-3+ MIT"

SLOT="0"

IUSE="debug lto test qt6"
REQUIRED_USE="
	lto? ( !debug )
"

RESTRICT="!test? ( test )"

MIN_QT6="6.4.0"
MIN_QT5="5.12.0"

QT5_DEPS="
	>=dev-qt/qtconcurrent-${MIN_QT5}:5
	>=dev-qt/qtgui-${MIN_QT5}:5
	>=dev-qt/qtnetwork-${MIN_QT5}:5
	>=dev-qt/qttest-${MIN_QT5}:5
	>=dev-qt/qtwidgets-${MIN_QT5}:5
	>=dev-qt/qtxml-${MIN_QT5}:5
	>=dev-qt/qtcore-${MIN_QT5}:5
	>=dev-qt/qtcharts-${MIN_QT5}:5
	>=dev-qt/qtsvg-${MIN_QT5}:5
"

QT6_DEPS="
	>=dev-qt/qtbase-${MIN_QT6}:6
	>=dev-qt/qtcharts-${MIN_QT6}:6
	>=dev-qt/qtsvg-${MIN_QT6}:6
"

QT_DEPS="
	!qt6? ( $QT5_DEPS )
	qt6? ( $QT6_DEPS )
"

# Required at both build-time and run-time
COMMON_DEPENDS="
	${QT_DEPS}
	>=dev-libs/quazip-1.3:=[qt5(+)]
	sys-libs/zlib
"

BDEPEND="
	app-text/scdoc
	kde-frameworks/extra-cmake-modules
"

DEPEND="
	${COMMON_DEPENDS}
	media-libs/libglvnd
	>=virtual/jdk-1.8.0:*
"

# At run-time we don't depend on JDK, only JRE
# And we need more than just the GL headers
RDEPEND="
	${COMMON_DEPENDS}

	>=virtual/jre-1.8.0:*
	virtual/opengl
"

src_prepare() {
	cmake_src_prepare

	# Prevent conflicting with the user's flags
	# See https://bugs.gentoo.org/848765 for more info
	sed -i -e 's/-Werror//' -e 's/-D_FORTIFY_SOURCE=2//' CMakeLists.txt || die 'Failed to remove -Werror and -D_FORTIFY_SOURCE via sed'
}

src_configure(){
	if use qt6
	then
		QT_VER=6
	else
		QT_VER=5
	fi

	echo $QT_VER
	echo $(usex qt6)

	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="/usr"
		# Resulting binary is named pollymc
		-DLauncher_APP_BINARY_NAME="${PN}"

		-DLauncher_QT_VERSION_MAJOR=${QT_VER}

		-DENABLE_LTO=$(usex lto)
		-DBUILD_TESTING=$(usex test)
	)

	if use debug; then
		CMAKE_BUILD_TYPE=Debug
	else
		CMAKE_BUILD_TYPE=Release
	fi

	cmake_src_configure
}

src_compile(){
	cmake_src_compile
}

pkg_postinst() {
	xdg_pkg_postinst

	# https://github.com/PolyMC/PolyMC/issues/227
	optfeature "old Minecraft (<= 1.12.2) support" x11-apps/xrandr

	optfeature "built-in MangoHud support" games-util/mangohud
	optfeature "built-in Feral Gamemode support" games-util/gamemode
}
