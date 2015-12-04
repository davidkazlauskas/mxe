# This file is part of MXE.
# See index.html for further information.

PKG             := xrender
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.9.7
$(PKG)_CHECKSUM := f9b46b93c9bc15d5745d193835ac9ba2a2b411878fad60c504bbb8f98492bbe6
$(PKG)_SUBDIR   := libXrender-$($(PKG)_VERSION)
$(PKG)_FILE     := libXrender-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://www.x.org/releases/X11R7.7/src/everything/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc xlib xorg-macros xrenderproto

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://curl.haxx.se/download/?C=M;O=D' | \
    $(SED) -n 's,.*curl-\([0-9][^"]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        CFLAGS="$(CFLAGS) -fPIC" \
        CXXFLAGS="$(CXXFLAGS) -fPIC"
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
