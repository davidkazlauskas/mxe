# This file is part of MXE.
# See index.html for further information.

PKG             := at-spi2-core
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.16.0
$(PKG)_CHECKSUM := 1c0b77fb8ce81abbf1d80c0afee9858b3f9229f673b7881995fe0fc16b1a74d0
$(PKG)_SUBDIR   := at-spi2-core-$($(PKG)_VERSION)
$(PKG)_FILE     := at-spi2-core-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://ftp.gnome.org/pub/gnome/sources/at-spi2-core/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://git.gnome.org/browse/atk/refs/tags' | \
    grep '<a href=' | \
    $(SED) -n "s,.*<a href='[^']*/tag/?id=ATK_\\([0-9]*_[0-9]*[02468]_[^<]*\\)'.*,\\1,p" | \
    $(SED) 's,_,.,g' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1)' -j '$(JOBS)' $(MXE_DISABLE_CRUFT) SUBDIRS='atk po' SHELL=bash
    $(MAKE) -C '$(1)' -j 1 install $(MXE_DISABLE_CRUFT) SUBDIRS='atk po'
endef
