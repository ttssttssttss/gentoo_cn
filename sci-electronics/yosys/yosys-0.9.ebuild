# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit python-single-r1

ABC_GIT_COMMIT="3709744"
DESCRIPTION="Framework for Verilog RTL synthesis"
HOMEPAGE="http://www.clifford.at/yosys/"
SRC_URI="https://github.com/YosysHQ/yosys/archive/yosys-0.9.tar.gz
	https://github.com/berkeley-abc/abc/archive/$ABC_GIT_COMMIT.tar.gz -> abc-$ABC_GIT_COMMIT.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="+abc clang libffi libedit readline python"
REQUIRED_USE="libedit? ( !readline )
	python? ( ${PYTHON_REQUIRED_USE} )"

BDEPEND="clang? ( sys-devel/clang )
	sys-devel/flex
	sys-devel/bison
	virtual/pkgconfig
"
DEPEND="!readline? ( libedit? ( dev-libs/libedit:= ) )
	readline? (
		sys-libs/readline:=
		sys-libs/ncurses:=
	)
	dev-lang/tcl:=
	python? ( $(python_gen_cond_dep 'dev-libs/boost[${PYTHON_USEDEP}]') )
	libffi? ( dev-libs/libffi )
	sys-libs/zlib
"
RDEPEND="${DEPEND}
	python? ( ${PYTHON_DEPS} )
	media-gfx/xdot
"

S="${WORKDIR}/yosys-${P}"

src_prepare() {
	default
	local sedcmds=(
		-e 's#$(PYTHON_EXECUTABLE)-config --libs#& --embed#g'
		-e 's#^ABCREV =.*#ABCREV = default#'
		-e '\#^.PHONY: abc\/.*#d'
	)
	sed -i "${sedcmds[@]}" Makefile || die

	ln -s ../abc-${ABC_GIT_COMMIT}* abc
}

src_configure() {
	if use clang ; then
		emake config-clang
	else
		emake config-gcc
	fi
	cat <<-__EOF__ >> Makefile.conf
		PREFIX := ${EPREFIX}/usr
		STRIP := @echo "skipping strip"
		ENABLE_ABC := $(usex abc 1 0)
		ENABLE_PLUGINS := $(usex libffi 1 0)
		ENABLE_READLINE := $(usex readline 1 0)
		ENABLE_EDITLINE := $(usex libedit 1 0)
		ENABLE_PYOSYS := $(usex python 1 0)
	__EOF__
}
