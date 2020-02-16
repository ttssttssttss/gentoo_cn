# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PV="$(ver_cut 4)"

DESCRIPTION="Foxit Reader,an PDF file reader"
HOMEPAGE="https://www.foxitsoftware.cn/"

KEYWORDS="~amd64"

SRC_URI="http://cdn01.foxitsoftware.com/pub/foxit/reader/desktop/linux/2.x/2.4/en_us/FoxitReader.enu.setup.2.4.4.0911.x64.run.tar.gz"

SLOT="0"
IUSE=""

RDEPEND=""
DEPEND=""
BDEPEND=""

S="${WORKDIR}"

src_unpack() {
    unpack FoxitReader.enu.setup.2.4.4.0911.x64.run.tar.gz
}

src_install() {
	bash "$S/*.run"
}
