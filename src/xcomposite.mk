# This file is part of MXE.
# See index.html for further information.

PKG             := xcomposite
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.4.3
$(PKG)_CHECKSUM := 32294d28f4ee46db310c344546d98484728b7d52158c6d7c25bba02563b41aad
$(PKG)_SUBDIR   := libXcomposite-$($(PKG)_VERSION)
$(PKG)_FILE     := libXcomposite-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://www.x.org/releases/X11R7.7/src/everything/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc xlib xfixes xcompositeproto

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
