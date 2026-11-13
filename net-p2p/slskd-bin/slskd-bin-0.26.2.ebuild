EAPI=8

DESCRIPTION="A modern client-server application for the Soulseek file sharing network."
HOMEPAGE="https://slskd.org https://github.com/slskd/slskd"

KEYWORDS="~amd64 ~arm ~arm64"
SRC_URI="
	amd64? (
		elibc_glibc? (
			https://github.com/slskd/slskd/releases/download/${PV}/slskd-${PV}-linux-x64.zip
		)
		elibc_musl? (
			https://github.com/slskd/slskd/releases/download/${PV}/slskd-${PV}-linux-musl-x64.zip
		)
	)
	arm64? (
		elibc_glibc? (
			https://github.com/slskd/slskd/releases/download/${PV}/slskd-${PV}-linux-arm64.zip
		)
		elibc_musl? (
			https://github.com/slskd/slskd/releases/download/${PV}/slskd-${PV}-linux-musl-arm64.zip
		)
	)
	arm? (
		elibc_glibc? (
			https://github.com/slskd/slskd/releases/download/${PV}/slskd-${PV}-linux-arm.zip
		)
		elibc_musl? (
			https://github.com/slskd/slskd/releases/download/${PV}/slskd-${PV}-linux-musl-arm.zip
		)
	)
"
S="$WORKDIR"

LICENSE="AGPL-3"
SLOT="0"

# If binary is stripped these errors will appear:
# Failure processing application bundle; possible file corruption.
# Arithmetic overflow while reading bundle.
# A fatal error occurred while processing application bundle
RESTRICT="strip"
QA_PREBUILT="*"

src_install() {
	mkdir -p "${ED}/opt/${PN}" || die
	cp -a * "${ED}/opt/${PN}" || die
	dosym "../${PN}/slskd" /opt/bin/slskd
}

