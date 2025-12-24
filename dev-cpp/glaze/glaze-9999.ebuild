EAPI=8

inherit cmake

DESCRIPTION="Extremely fast, in memory, JSON and interface library for modern C++"
HOMEPAGE="https://github.com/stephenberry/glaze"

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/stephenberry/${PN}.git"
	inherit git-r3
else
    SRC_URI="https://github.com/stephenberry/glaze/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

#S="${WORKDIR}/glaze-${PV}"

LICENSE="MIT"
SLOT="0"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_SKIP_INSTALL_RULES=OFF
		-Dglaze_DEVELOPER_MODE=ON
		-Dglaze_ENABLE_FUZZING=no
		-Dglaze_BUILD_EXAMPLES=no
		-DBUILD_TESTING=no
	)

	cmake_src_configure
}
