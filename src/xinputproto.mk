# This file is part of MXE.
# See index.html for further information.

PKG             := xinputproto
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.2
$(PKG)_CHECKSUM := de7516ab25c299740da46c0f1af02f1831c5aa93b7283f512c0f35edaac2bcb0
$(PKG)_SUBDIR   := inputproto-$($(PKG)_VERSION)
$(PKG)_FILE     := inputproto-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://www.x.org/releases/X11R7.7/src/everything/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://curl.haxx.se/download/?C=M;O=D' | \
    $(SED) -n 's,.*curl-\([0-9][^"]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
