# This file is part of MXE.
# See index.html for further information.

PKG             := xinerama
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.1.2
$(PKG)_CHECKSUM := a4e77c2fd88372e4ae365f3ca0434a23613da96c5b359b1a64bf43614ec06aac
$(PKG)_SUBDIR   := libXinerama-$($(PKG)_VERSION)
$(PKG)_FILE     := libXinerama-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://www.x.org/releases/X11R7.7/src/everything/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc xlib xineramaproto xext

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
