# This file is part of MXE.
# See index.html for further information.

PKG             := xdamageproto
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.2.1
$(PKG)_CHECKSUM := 5c7c112e9b9ea8a9d5b019e5f17d481ae20f766cb7a4648360e7c1b46fc9fc5b
$(PKG)_SUBDIR   := damageproto-$($(PKG)_VERSION)
$(PKG)_FILE     := damageproto-$($(PKG)_VERSION).tar.bz2
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
