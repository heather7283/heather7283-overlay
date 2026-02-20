EAPI=8

DESCRIPTION="A lightweight TUI (ncurses-like) display manager for Linux and BSD"
HOMEPAGE="https://codeberg.org/fairyglade/ly"

declare -g -r -A ZBS_DEPENDENCIES=(
	[clap-0.11.0-oBajB-HnAQDPCKYzwF7rO3qDFwRcD39Q0DALlTSz5H7e.tar.gz]='https://github.com/Hejsil/zig-clap/archive/5289e0753cd274d65344bef1c114284c633536ea.tar.gz'
	[ini-0.1.0-YCQ9Ys0pAABixEvvQvhVXAdqRE3wrZk_wiL9TPNHhB8d.tar.gz]='https://github.com/AnErrupTion/ini/archive/918f16d0dcf893d0c1cdffe204faa08bb3584e04.tar.gz'
	[zigini-0.3.3-36M0FRJJAADZVq5HPm-hYKMpFFTr0OgjbEYcK2ijKZ5n.tar.gz]='https://github.com/AnErrupTion/zigini/archive/9281f47702b57779e831d7618e158abb8eb4d4a2.tar.gz'
	[N-V-__8AAOEWBQDt5tNdIzIFY6n8DdZsCP-6MyLoNS20wgpA.tar.gz]='https://github.com/AnErrupTion/termbox2/archive/496730697c662893eec43192f48ff616c2539da6.tar.gz'
)

ZIG_SLOT="0.15"
inherit pam systemd zig

SRC_URI="
	https://codeberg.org/fairyglade/${PN}/archive/v${PV}.tar.gz
	${ZBS_DEPENDENCIES_SRC_URI}
"

S="${WORKDIR}/${PN}"

LICENSE="WTFPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="X"

RDEPEND="
	app-misc/brightnessctl
	sys-libs/pam
	sys-libs/ncurses
	X? (
		x11-base/xorg-server
		x11-apps/xauth
		x11-apps/xrdb
		x11-apps/xmessage
		x11-libs/libxcb
	)
"
DEPEND="
    ${RDEPEND}
"

src_configure() {
	local my_zbs_args=(
		-Denable_x11_support=$(usex X true false)
	)
	zig_src_configure
}

src_install() {
    local res="${S}/res"
	sed -e "s|\$PREFIX_DIRECTORY|/usr|g" \
	    -e "s|\$EXECUTABLE_NAME|ly|g" \
	    -e "s|\$DEFAULT_TTY|2|g" \
	    -e "s|\$CONFIG_DIRECTORY|/etc|g" \
	    -i "${res}/${PN}@.service" \
	    -i "${res}/${PN}-openrc" \
	    -i "${res}/config.ini"

	dobin "${WORKDIR}/${P}-build/usr/bin/${PN}"
	newinitd "${res}/${PN}-openrc" ${PN}
	systemd_dounit "${res}/${PN}@.service"
	insinto /etc/${PN}
	doins "${res}/config.ini" "${res}/setup.sh"
	insinto "/etc/${PN}/lang"
	doins ${res}/lang/*.ini
	newpamd "${res}/pam.d/ly-linux" ly
	fperms +x /etc/${PN}/setup.sh
}

