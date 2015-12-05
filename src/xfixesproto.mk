# This file is part of MXE.
# See index.html for further information.

PKG             := xfixesproto
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.0
$(PKG)_CHECKSUM := ba2f3f31246bdd3f2a0acf8bd3b09ba99cab965c7fb2c2c92b7dc72870e424ce
$(PKG)_SUBDIR   := fixesproto-$($(PKG)_VERSION)
$(PKG)_FILE     := fixesproto-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://www.x.org/releases/X11R7.7/src/everything/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://curl.haxx.se/download/?C=M;O=D' | \
    $(SED) -n 's,.*curl-\([0-9][^"]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        CFLAGS="$(CFLAGS) -fPIC" \
        CXXFLAGS="$(CXXFLAGS) -fPIC"
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
