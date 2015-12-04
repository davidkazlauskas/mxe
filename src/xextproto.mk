# This file is part of MXE.
# See index.html for further information.

PKG             := xextproto
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 7.2.1
$(PKG)_CHECKSUM := 7c53b105407ef3b2eb180a361bd672c1814524a600166a0a7dbbe76b97556d1a
$(PKG)_SUBDIR   := xextproto-$($(PKG)_VERSION)
$(PKG)_FILE     := xextproto-$($(PKG)_VERSION).tar.bz2
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
