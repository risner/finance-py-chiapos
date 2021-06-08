PORTNAME=	chiapos
DISTVERSION=	1.0.3
CATEGORIES=	finance python
MASTER_SITES=	CHEESESHOP
PKGNAMEPREFIX=	${PYTHON_PKGNAMEPREFIX}
DISTFILES=	${DISTNAME}${EXTRACT_SUFX}

MAINTAINER=	risner@stdio.com
COMMENT=	Chia proof of space plotting, proving, and verifying (wraps C++)

LICENSE=	APACHE20
LICENSE_FILE=	${WRKSRC}/LICENSE

BUILD_DEPENDS=	${PYTHON_PKGNAMEPREFIX}setuptools_scm>=3.5.0:devel/py-setuptools_scm@${PY_FLAVOR} \
		cmake>=3.12:devel/cmake \
		pybind11>0:devel/pybind11

USES=		cmake:noninja python:3.7+
USE_GITHUB=	nodefault
GH_TUPLE=	jarro2783:cxxopts:302302b30839505703d37fb82f536c53cf9172fa:c/src-ext/cxxopts \
		gulrak:filesystem:4e21ab305794f5309a1454b4ae82ab9a0f5e0d25:g/src-ext/gulrak
USE_PYTHON=	concurrent distutils
PYSETUP=	${WRKSRC}/setup.py
CMAKE_ARGS+=	-DCOMPILER_CXXFLAGS="${CXXFLAGS}" \
		-DCOMPILER_FLAGS="${CFLAGS}"

post-extract:
	@${CP} ${FILESDIR}/Hellman-Makefile ${WRKSRC}/hellman_example/Makefile

do-build:
	@(cd ${BUILD_WRKSRC}; if ! ${DO_MAKE_BUILD} ${ALL_TARGET}; then \
		if [ -n "${BUILD_FAIL_MESSAGE}" ] ; then \
			${ECHO_MSG} "===> Compilation failed unexpectedly."; \
			(${ECHO_CMD} "${BUILD_FAIL_MESSAGE}") | ${FMT_80} ; \
			fi; \
		${FALSE}; \
		fi)
	@(cd ${BUILD_WRKSRC} && ${STRIP_CMD} ProofOfSpace RunTests ${PORTNAME}.cpython-${PYTHON_SUFFIX}.so)

# The upstream uses cmake as a subroutine from python setuptools.
#	To handle this, I must compile the C code via cmake, and run distutils
#	from a curated directory in ${INSTALL_WRKSRC}.
# Currently I don't know how to teach setuptools to look in a directory
#	other than ${INSTALL_WRKSRC}/build/lib.${os}-${plat}-${PYTHON_SUFFIX}.
do-install:
	@(cd ${INSTALL_WRKSRC} && ${SETENV} ${MAKE_ENV} ${FAKEROOT} ${MAKE_CMD} ${MAKE_FLAGS} ${MAKEFILE} ${MAKE_ARGS} ${INSTALL_TARGET})
	@(cd ${INSTALL_WRKSRC}; ${RM} -rf build; \
		${MKDIR} build/lib.freebsd-13.0-RELEASE-amd64-3.8; \
		${MKDIR} build/script; \
		${CP} ${INSTALL_WRKSRC}/${PORTNAME}.cpython-${PYTHON_SUFFIX}.so \
			build/lib.freebsd-13.0-RELEASE-amd64-3.8; \
		${CP} ${WRKSRC}/README.md .; \
		${CP} ${WRKSRC}/tools/parse_disk.py \
			build/script; )
	@(cd ${INSTALL_WRKSRC}; ${SETENV} ${MAKE_ENV} ${PYTHON_CMD} \
		${PYDISTUTILS_SETUP} ${PYDISTUTILS_INSTALL_TARGET} \
		${PYDISTUTILS_INSTALLARGS} --skip-build )

.include <bsd.port.mk>
