# This file is part of MXE.
# See index.html for further information.

PKG             := xlib
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.5.0
$(PKG)_CHECKSUM := c382efd7e92bfc3cef39a4b7f1ecf2744ba4414a705e3bc1e697f75502bd4d86
$(PKG)_SUBDIR   := libX11-$($(PKG)_VERSION)
$(PKG)_FILE     := libX11-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://www.x.org/releases/X11R7.7/src/lib/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc xproto xcblib xextproto xtrans xkbproto

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
