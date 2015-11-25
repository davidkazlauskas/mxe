# This file is part of MXE.
# See index.html for further information.

PKG             := linux-headers
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.6.32.68
$(PKG)_CHECKSUM := f56ca7f9ae41a80b37b42a9aa6367d6b054cde8a32ef3585a8b7b1fecd1c399e
$(PKG)_SUBDIR   := linux-$($(PKG)_VERSION)
$(PKG)_FILE     := linux-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://cdn.kernel.org/pub/linux/kernel/v2.6/longterm/v2.6.32/$($(PKG)_FILE)
$(PKG)_DEPS     :=

