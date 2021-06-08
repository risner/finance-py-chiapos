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
# USE_PYTHON=     autoplist concurrent distutils
CMAKE_ARGS+=	-DCOMPILER_CXXFLAGS="${CXXFLAGS}" \
		-DCOMPILER_FLAGS="${CFLAGS}"

# Used to test stripping/not stripping
#WITH_DEBUG=	yes

# ?? -DOPENCASCADE_INCLUDE_DIR=${OCCT} -DPYTHON_EXECUTABLE=${PYTHON_CMD}
# ?? CMAKE_ARGS+=    -DPYTHON_VERSION:STRING=${PYTHON_VER}

post-extract:
	@${CP} ${FILESDIR}/Hellman-Makefile ${WRKSRC}/hellman_example/Makefile

do-build:
# Do cmake build
	@(cd ${BUILD_WRKSRC}; if ! ${DO_MAKE_BUILD} ${ALL_TARGET}; then \
		if [ -n "${BUILD_FAIL_MESSAGE}" ] ; then \
			${ECHO_MSG} "===> Compilation failed unexpectedly."; \
			(${ECHO_CMD} "${BUILD_FAIL_MESSAGE}") | ${FMT_80} ; \
			fi; \
		${FALSE}; \
		fi)
# Strip if desired
	@(cd ${BUILD_WRKSRC} && ${STRIP_CMD} ProofOfSpace RunTests ${PORTNAME}.cpython-${PYTHON_SUFFIX}.so)
# Do python build
# (cd ${WRKSRC}; ${SETENV} ${MAKE_ENV} ${PYTHON_CMD} ${PYDISTUTILS_SETUP} ${PYDISTUTILS_BUILD_TARGET} ${PYDISTUTILS_BUILDARGS})

do-install:
# Do cmake install
	@(cd ${INSTALL_WRKSRC} && ${SETENV} ${MAKE_ENV} ${FAKEROOT} ${MAKE_CMD} ${MAKE_FLAGS} ${MAKEFILE} ${MAKE_ARGS} ${INSTALL_TARGET})
# Do python install
	${INSTALL_LIB} ${BUILD_WRKSRC}/${PORTNAME}.cpython-${PYTHON_SUFFIX}.so ${STAGEDIR}${PREFIX}/lib
# Try to make site-packages?
	(cd ${STAGEDIR}${PREFIX} && ${PYTHON_CMD} \
		${PYTHON_LIBDIR}/compileall.py -d ${PREFIX} \
		-f ${PYTHONPREFIX_SITELIBDIR:S,${PREFIX}/,,})
	(cd ${STAGEDIR}${PREFIX} && ${PYTHON_CMD} -O \
		${PYTHON_LIBDIR}/compileall.py \
		-d ${PREFIX} -f ${PYTHONPREFIX_SITELIBDIR:S,${PREFIX}/,,})

#	${INSTALL_LIB} ${WRKDIR}/.build/${PORTNAME}.cpython-${PYTHON_SUFFIX}.so ${STAGEDIR}${PREFIX}/lib
#	${INSTALL_DATA} ${WRKDIR}/.build/${PORTNAME}.cpython-${PYTHON_SUFFIX}.so ${STAGEDIR}${PREFIX}/lib
#	# Do python install
#	# @(cd ${INSTALL_WRKSRC}; ${SETENV} ${MAKE_ENV} ${PYTHON_CMD} ${PYDISTUTILS_SETUP} ${PYDISTUTILS_INSTALL_TARGET} ${PYDISTUTILS_INSTALLARGS})

post-test:
	${WRKSRC}/build/temp.freebsd*/RunTests

.include <bsd.port.mk>
