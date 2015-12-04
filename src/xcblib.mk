# This file is part of MXE.
# See index.html for further information.

PKG             := xcblib
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.8.1
$(PKG)_CHECKSUM := d2f46811e950710e7e79e45615d24f2c7ec318b9de9dc717972723da58bffa0d
$(PKG)_SUBDIR   := libxcb-$($(PKG)_VERSION)
$(PKG)_FILE     := libxcb-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://www.x.org/releases/X11R7.7/src/xcb/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc xcbproto pthread-stubs xaulib

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
