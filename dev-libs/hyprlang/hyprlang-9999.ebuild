EAPI=8

inherit cmake

DESCRIPTION="Official implementation library for the hypr config language"
HOMEPAGE="https://github.com/hyprwm/hyprlang"

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/hyprwm/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/hyprwm/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="LGPL-3"
SLOT="0"

RDEPEND=">=gui-libs/hyprutils-0.7.1:="
DEPEND="${RDEPEND}"

