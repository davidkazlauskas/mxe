# This file is part of MXE.
# See index.html for further information.

PKG             := xi
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.6.1
$(PKG)_CHECKSUM := f2e3627d7292ec5eff488ab58867fba14a62f06e72a8d3337ab6222c09873109
$(PKG)_SUBDIR   := libXi-$($(PKG)_VERSION)
$(PKG)_FILE     := libXi-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://www.x.org/releases/X11R7.7/src/everything/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc xext

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
