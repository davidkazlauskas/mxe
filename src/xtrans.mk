# This file is part of MXE.
# See index.html for further information.

PKG             := xtrans
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.2.7
$(PKG)_CHECKSUM := 7f811191ba70a34a9994d165ea11a239e52c527f039b6e7f5011588f075fe1a6
$(PKG)_SUBDIR   := xtrans-$($(PKG)_VERSION)
$(PKG)_FILE     := xtrans-$($(PKG)_VERSION).tar.bz2
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
