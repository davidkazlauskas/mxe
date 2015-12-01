# This file is part of MXE.
# See index.html for further information.

PKG             := xtst
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.2.1
$(PKG)_CHECKSUM := 7eea3e66e392aca3f9dad6238198753c28e1c32fa4903cbb7739607a2504e5e0
$(PKG)_SUBDIR   := libXtst-$($(PKG)_VERSION)
$(PKG)_FILE     := libXtst-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://www.x.org/releases/X11R7.7/src/everything/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc xrecordproto

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://curl.haxx.se/download/?C=M;O=D' | \
    $(SED) -n 's,.*curl-\([0-9][^"]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
		XTST_LIBS="-lX11 -lxcb"
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
