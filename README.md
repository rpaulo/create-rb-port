# create-rb-port

Creates a FreeBSD rubygem port based on a Gemfile spec retrieved automatically
from RubyGems.org

Example:
```
# console
% ./create-rb-port.rb autotest
Downloading metadata for Gem 'autotest'...
Found autotest version 4.4.6
Creating Makefile...
Creating pkg-descr...
Port generation complete in directory rubygem-autotest
% ls rubygem-autotest
Makefile
pkg-descr
% cat rubygem-autotest/Makefile
# Created by: XXX <foo@bar.com>
# $FreeBSD$

PORTNAME=	autotest
PORTVERSION=	4.4.6
CATEGORIES=	rubygems CATEGORY
MASTER_SITES=	RG

MAINTAINER=	ruby@FreeBSD.org
COMMENT=	This is a stub gem to fix the confusion caused by autotest being part of the ZenTest suite

LICENSE=	????

RUN_DEPENDS=	rubygem-ZenTest>=4.4.1:${PORTSDIR}/CATEGORY/rubygem-ZenTest
		rubygem-rubyforge>=2.0.4:${PORTSDIR}/CATEGORY/rubygem-rubyforge
		rubygem-minitest>=1.6.0:${PORTSDIR}/CATEGORY/rubygem-minitest
		rubygem-hoe>=2.6.0:${PORTSDIR}/CATEGORY/rubygem-hoe
USE_RUBY=	yes
USE_RUBYGEMS=	yes
RUBYGEM_AUTOPLIST=yes

PLIST_FILES=

.include <bsd.port.mk>
% cat rubygem-autotest/pkg-descr
This is a stub gem to fix the confusion caused by autotest being part
of the ZenTest suite.

WWW: http://www.zenspider.com/ZSS/Products/ZenTest/
```
