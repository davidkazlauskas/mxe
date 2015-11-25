# This file is part of MXE.
# See index.html for further information.

PKG             := glibc
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.22
$(PKG)_CHECKSUM := eb731406903befef1d8f878a46be75ef862b9056ab0cde1626d08a7a05328948
$(PKG)_SUBDIR   := glibc-$($(PKG)_VERSION)
$(PKG)_FILE     := glibc-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://ftp.gnu.org/gnu/glibc/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS)

    $(MAKE) -C '$(1)' -j '$(JOBS)' install $(MXE_DISABLE_DOCS)
endef
