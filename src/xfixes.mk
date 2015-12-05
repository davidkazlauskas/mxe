# This file is part of MXE.
# See index.html for further information.

PKG             := xfixes
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.0
$(PKG)_CHECKSUM := 537a2446129242737a35db40081be4bbcc126e56c03bf5f2b142b10a79cda2e3
$(PKG)_SUBDIR   := libXfixes-$($(PKG)_VERSION)
$(PKG)_FILE     := libXfixes-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://www.x.org/releases/X11R7.7/src/everything/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc xlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://curl.haxx.se/download/?C=M;O=D' | \
    $(SED) -n 's,.*curl-\([0-9][^"]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
		--enable-shared \
		--disable-static
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
