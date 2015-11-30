# This file is part of MXE.
# See index.html for further information.

PKG             := xrenderproto
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.11.1
$(PKG)_CHECKSUM := 06735a5b92b20759204e4751ecd6064a2ad8a6246bb65b3078b862a00def2537
$(PKG)_SUBDIR   := renderproto-$($(PKG)_VERSION)
$(PKG)_FILE     := renderproto-$($(PKG)_VERSION).tar.bz2
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
