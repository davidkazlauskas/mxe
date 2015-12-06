# This file is part of MXE.
# See index.html for further information.

PKG             := xdamage
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.1.3
$(PKG)_CHECKSUM := bc6169c826d3cb17435ca84e1b479d65e4b51df1e48bbc3ec39a9cabf842c7a8
$(PKG)_SUBDIR   := libXdamage-$($(PKG)_VERSION)
$(PKG)_FILE     := libXdamage-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://www.x.org/releases/X11R7.7/src/everything/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc xdamageproto xlib xfixes

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
