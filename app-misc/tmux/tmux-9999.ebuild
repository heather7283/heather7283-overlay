EAPI=8

inherit autotools flag-o-matic systemd

DESCRIPTION="Terminal multiplexer"
HOMEPAGE="https://tmux.github.io/"

inherit git-r3
SRC_URI="https://raw.githubusercontent.com/przepompownia/tmux-bash-completion/678a27616b70c649c6701cae9cd8c92b58cc051b/completions/tmux -> tmux-bash-completion-678a27616b70c649c6701cae9cd8c92b58cc051b"
EGIT_REPO_URI="https://github.com/tmux/tmux.git"

LICENSE="ISC"
SLOT="0"
IUSE="debug selinux systemd utempter sixel vim-syntax"

DEPEND="
	dev-libs/libevent:=
	sys-libs/ncurses:=
	systemd? ( sys-apps/systemd:= )
	utempter? ( sys-libs/libutempter )
    sixel? ( media-libs/libsixel )
	kernel_Darwin? ( dev-libs/libutf8proc:= )
"

BDEPEND="
	virtual/pkgconfig
	app-alternatives/yacc
"

RDEPEND="
	${DEPEND}
	selinux? ( sec-policy/selinux-screen )
	vim-syntax? ( app-vim/vim-tmux )
"

# BSD only functions
QA_CONFIG_IMPL_DECL_SKIP=( strtonum recallocarray )

DOCS=( CHANGES README )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# bug 438558
	# 1.7 segfaults when entering copy mode if compiled with -Os
	replace-flags -Os -O2

	local myeconfargs=(
		--sysconfdir="${EPREFIX}"/etc
		$(use_enable debug)
		$(use_enable systemd)
		$(use_enable utempter)
        $(use_enable sixel)

		# For now, we only expose this for macOS, because
		# upstream strongly encourage it. I'm not sure it's
		# needed on Linux right now.
		$(use_enable kernel_Darwin utf8proc)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	einstalldocs

	dodoc example_tmux.conf
	docompress -x /usr/share/doc/${PF}/example_tmux.conf

	if use systemd; then
		systemd_newuserunit "${FILESDIR}"/tmux.service tmux@.service
		systemd_newuserunit "${FILESDIR}"/tmux.socket tmux@.socket
	fi
}
