# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
PYTHON_COMPAT=(python2_7 python3_{5,6})

inherit distutils-r1

DESCRIPTION="Google's Protocol Buffers - Python bindings"
HOMEPAGE="https://developers.google.com/protocol-buffers/ https://github.com/protocolbuffers/protobuf"
SRC_URI="https://github.com/protocolbuffers/protobuf/archive/v${PV}.tar.gz -> protobuf-${PV}.tar.gz"

LICENSE="BSD"
SLOT="0/15"
KEYWORDS="alpha amd64 arm ~arm64 ~hppa ia64 ~mips ppc ppc64 ~sh ~sparc x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE=""

DEPEND="${PYTHON_DEPS}
	~dev-libs/protobuf-${PV}
	dev-python/namespace-google[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
	!<dev-libs/protobuf-3[python(-)]"

S="${WORKDIR}/protobuf-${PV}/python"

python_prepare_all() {
	eapply -p2 "${FILESDIR}/${P}-google.protobuf.pyext._message.MessageMeta.patch"
	distutils-r1_python_prepare_all
}

python_configure_all() {
	mydistutilsargs=(--cpp_implementation)
}

python_compile() {
	python_is_python3 || local -x CXXFLAGS="${CXXFLAGS} -fno-strict-aliasing"
	distutils-r1_python_compile
}

python_test() {
	esetup.py test
}

python_install_all() {
	distutils-r1_python_install_all

	find "${D}" -name "*.pth" -delete || die
}
