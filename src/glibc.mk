# This file is part of MXE.
# See index.html for further information.

PKG             := glibc
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.22
$(PKG)_CHECKSUM := 96cd9711d8f38fa6f99af085a67ad1e0ebca339f2a9a00a2aa59c40a66c4552d
$(PKG)_SUBDIR   := glibc-$($(PKG)_VERSION)
$(PKG)_FILE     := glibc-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://ftp.gnu.org/gnu/glibc/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS)

    $(MAKE) -C '$(1)' -j '$(JOBS)' install $(MXE_DISABLE_DOCS)
endef
