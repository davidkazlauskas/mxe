# This file is part of MXE.
# See index.html for further information.

PKG             := xproto
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 7.0.23
$(PKG)_CHECKSUM := ade04a0949ebe4e3ef34bb2183b1ae8e08f6f9c7571729c9db38212742ac939e
$(PKG)_SUBDIR   := xproto-$($(PKG)_VERSION)
$(PKG)_FILE     := xproto-$($(PKG)_VERSION).tar.bz2
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
