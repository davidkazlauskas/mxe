# This file is part of MXE.
# See index.html for further information.

PKG             := xrecordproto
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.14.2
$(PKG)_CHECKSUM := a777548d2e92aa259f1528de3c4a36d15e07a4650d0976573a8e2ff5437e7370
$(PKG)_SUBDIR   := recordproto-$($(PKG)_VERSION)
$(PKG)_FILE     := recordproto-$($(PKG)_VERSION).tar.bz2
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
