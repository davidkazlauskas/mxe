# This file is part of MXE.
# See index.html for further information.

PKG             := linux-headers
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.2.82
$(PKG)_CHECKSUM := 7fcb68199f5bddbe074ef3c220b1a27cf8cb38d41413dee2d6c289bb7c0fd7ec
$(PKG)_SUBDIR   := linux-$($(PKG)_VERSION)
$(PKG)_FILE     := linux-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://cdn.kernel.org/pub/linux/kernel/v3.x/$($(PKG)_FILE)
$(PKG)_DEPS     :=

