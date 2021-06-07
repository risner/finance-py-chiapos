PORTNAME=	chiapos
DISTVERSION=	1.0.3
CATEGORIES=	finance python
MASTER_SITES=	CHEESESHOP
PKGNAMEPREFIX=	${PYTHON_PKGNAMEPREFIX}

MAINTAINER=	risner@stdio.com
COMMENT=	Chia proof of space plotting, proving, and verifying (wraps C++)

LICENSE=	APACHE20
LICENSE_FILE=	${WRKSRC}/LICENSE

BUILD_DEPENDS=	${PYTHON_PKGNAMEPREFIX}pybind11>0:devel/py-pybind11@${PY_FLAVOR}

USES=		cmake:insource,noninja python:3.7+
USE_CXXSTD=	c++17
USE_PYTHON=	autoplist concurrent distutils

CONFIGURE_WRKSRC=	${WRKSRC}/build

post-test:
	${WRKSRC}/build/temp.freebsd*/RunTests

.include <bsd.port.mk>
