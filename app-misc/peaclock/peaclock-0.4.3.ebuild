EAPI=8

inherit cmake

DESCRIPTION="A responsive and customizable clock, timer, and stopwatch for the terminal."
HOMEPAGE="https://octobanana.com/software/peaclock"

if [[ ${PV} = 9999 ]]; then
    inherit git-r3
    EGIT_REPO_URI="https://github.com/octobanana/${PN}.git"
else
    SRC_URI="https://github.com/octobanana/${PN}/archive/refs/tags/${PV}.tar.gz"
    KEYWORDS="~amd64"
fi

LICENSE="MIT"
SLOT="0"

RDEPEND="
	dev-libs/icu
"
DEPEND="
    ${RDEPEND}
"

