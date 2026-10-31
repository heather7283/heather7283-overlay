EAPI=8

inherit meson

DESCRIPTION="Run commands in response to evdev events according to rules"
HOMEPAGE="https://github.com/heather7283/evdevd"

if [[ ${PV} == 9999 ]]; then
    inherit git-r3
    EGIT_REPO_URI="https://github.com/heather7283/evdevd.git"
else
    SRC_URI="https://github.com/heather7283/evdevd/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
    KEYWORDS="~amd64 ~arm"
fi

LICENSE="GPL-3+"
SLOT="0"

