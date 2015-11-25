# This file is part of MXE.
# See index.html for further information.

PKG             := glibc
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.22
$(PKG)_CHECKSUM := bb6af651ca90960b040cabc73b1e799e25a607c0a5dea0bddbf1b52e2b1bcb87
$(PKG)_SUBDIR   := glibc-$($(PKG)_VERSION)
$(PKG)_FILE     := glibc-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://ftp.gnu.org/gnu/glibc/$($(PKG)_FILE)
$(PKG)_DEPS     :=

