# $FreeBSD$

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
		pybind11>0:devel/pybind11

TEST_DEPENDS=	${PYTHON_PKGNAMEPREFIX}mypy>0:devel/py-mypy@${PY_FLAVOR} \
		${PYTHON_PKGNAMEPREFIX}flake8>0:devel/py-flake8@${PY_FLAVOR}

USES=		python:3.7+
USE_GITHUB=	nodefault
GH_TUPLE=	jarro2783:cxxopts:302302b30839505703d37fb82f536c53cf9172fa:c/src-ext/cxxopts \
		gulrak:filesystem:4e21ab305794f5309a1454b4ae82ab9a0f5e0d25:g/src-ext/gulrak
USE_PYTHON=	autoplist concurrent distutils

PYDISTUTILS_INSTALLARGS+=	--skip-build

post-extract:
# Remove extraneous unused files to prevent confusion
	@${RM} ${WRKSRC}/lib/FiniteStateEntropy/fetch-content-CMakeLists.txt
	@${RM} ${WRKSRC}/pyproject.toml

do-test: stage
	@(cd ${WRKSRC}; py.test ./tests -s -v)

.include <bsd.port.mk>
