PORTNAME=	chiapos
DISTVERSION=	1.0.3
CATEGORIES=	finance python
MASTER_SITES=	CHEESESHOP
PKGNAMEPREFIX=	${PYTHON_PKGNAMEPREFIX}
DISTFILES=	${DISTNAME}${EXTRACT_SUFX}
INSTALL_TARGET= install

MAINTAINER=	risner@stdio.com
COMMENT=	Chia proof of space plotting, proving, and verifying (wraps C++)

LICENSE=	APACHE20
LICENSE_FILE=	${WRKSRC}/LICENSE

BUILD_DEPENDS=	pybind11>0:devel/pybind11 cmake>=3.12:devel/cmake

USES=		cmake:noninja python:3.7+
USE_GITHUB=	nodefault
GH_TUPLE=	jarro2783:cxxopts:302302b30839505703d37fb82f536c53cf9172fa:c/src-ext/cxxopts \
		gulrak:filesystem:4e21ab305794f5309a1454b4ae82ab9a0f5e0d25:g/src-ext/gulrak

#CMAKE_ARGS+=	-Dcxxopts_SOURCE_DIR=${WRK_SRC}/src-ext/cxxopts/include \
#		-Dgulrak_SOURCE_DIR=${WRK_SRC}/src-ext/gulrak/include/ghc
#CMAKE_ARGS+=	${CMAKE_INSTALL_PREFIX}/share/cmake/pybind11/pybind11Config.cmake
# CMAKE_ARGS+=	-D cxxopts_SOURCE_DIR:PATH=src-ext/cxxopts
#  ${cxxopts_SOURCE_DIR}/include ${gulrak_SOURCE_DIR}/include/ghc
# need added to include: /usr/local/share/cmake/pybind11
# ?? -DOPENCASCADE_INCLUDE_DIR=${OCCT} -DPYTHON_EXECUTABLE=${PYTHON_CMD}
# ?? CMAKE_ARGS+=    -DPYTHON_VERSION:STRING=${PYTHON_VER}
# ?? -Dpybind11_DIR=<install-dir>/share/cmake/pybind11
#CONFIGURE_WRKSRC=	${WRKSRC}/build

post-test:
	${WRKSRC}/build/temp.freebsd*/RunTests

.include <bsd.port.mk>
