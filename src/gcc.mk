# This file is part of MXE.
# See index.html for further information.

PKG             := gcc
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.9.3
$(PKG)_CHECKSUM := 2332b2a5a321b57508b9031354a8503af6fdfb868b8c1748d33028d100a8b67e
$(PKG)_SUBDIR   := gcc-$($(PKG)_VERSION)
$(PKG)_FILE     := gcc-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://ftp.gnu.org/pub/gnu/gcc/gcc-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.mirrorservice.org/sites/sourceware.org/pub/gcc/releases/gcc-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := binutils glibc linux-headers

$(PKG)_FILE_$(BUILD) :=
$(PKG)_LIBGCC_FOLDER := $(PREFIX)/lib/gcc/$(TARGET)/$($(PKG)_VERSION)

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://ftp.gnu.org/gnu/gcc/?C=M;O=D' | \
    $(SED) -n 's,.*<a href="gcc-\([0-9][^"]*\)/".*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_CONFIGURE
    # configure gcc
    mkdir '$(1).build'
    cd    '$(1).build' && '$(1)/configure' \
        --target='$(TARGET)' \
        --build='$(BUILD)' \
        --prefix='$(PREFIX)' \
        --libdir='$(PREFIX)/lib' \
        --enable-languages='c,c++,objc,fortran' \
        --enable-version-specific-runtime-libs \
        --with-gcc \
        --with-gnu-ld \
        --with-gnu-as \
        --disable-nls \
        $(if $(BUILD_STATIC),--disable-shared) \
        --disable-multilib \
        --without-x \
        --disable-win32-registry \
        --enable-threads \
        --enable-libgomp \
        --with-gmp='$(PREFIX)/$(BUILD)' \
        --with-isl='$(PREFIX)/$(BUILD)' \
        --with-mpc='$(PREFIX)/$(BUILD)' \
        --with-mpfr='$(PREFIX)/$(BUILD)' \
        --with-cloog='$(PREFIX)/$(BUILD)' \
        --with-as='$(PREFIX)/bin/$(TARGET)-as' \
        --with-ld='$(PREFIX)/bin/$(TARGET)-ld' \
        --with-nm='$(PREFIX)/bin/$(TARGET)-nm' \
        $(shell [ `uname -s` == Darwin ] && echo "LDFLAGS='-Wl,-no_pie'")
endef

define $(PKG)_POST_BUILD
    # TODO: find a way to configure the installation of these correctly
    # ignore rm failure as parallel build may have cleaned up, but
    # don't wildcard all libs so future additions will be detected
    $(and $(BUILD_SHARED),
    mv  -v '$(PREFIX)/lib/gcc/$(TARGET)/$($(PKG)_VERSION)/'*.dll '$(PREFIX)/$(TARGET)/bin/gcc-$($(PKG)_VERSION)/'
    -rm -v '$(PREFIX)/lib/gcc/$(TARGET)/'libgcc_s*.dll
    -rm -v '$(PREFIX)/lib/gcc/$(TARGET)/lib/'libgcc_s*.a
    -rmdir '$(PREFIX)/lib/gcc/$(TARGET)/lib/')
endef

define $(PKG)_BUILD
    # extract linux headers
    $(call PREPARE_PKG_SOURCE,linux-headers,$(1))
    mkdir -p $(PREFIX)/$(TARGET)/include
    make -C "$(1)/$(linux-headers_SUBDIR)" headers_install ARCH=x86_64 INSTALL_HDR_PATH="$(PREFIX)/$(TARGET)"

    # build glibc headers
    $(call PREPARE_PKG_SOURCE,glibc,$(1))
    mkdir '$(1).headers-build'
    unset LD_LIBRARY_PATH && cd '$(1).headers-build' && '$(1)/$(glibc_SUBDIR)/configure' \
        --host='$(basename $(TARGET))' \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1).headers-build' install-headers

    # add sys-include
    cd '$(PREFIX)/$(TARGET)' && rm -f sys-include && ln -s include sys-include

    # build standalone gcc
    $($(PKG)_CONFIGURE)
    $(MAKE) -C '$(1).build' -j '$(JOBS)' all-gcc
    $(MAKE) -C '$(1).build' -j 1 install-gcc

    # build glibc
    $(call PREPARE_PKG_SOURCE,glibc,$(1))
    mkdir '$(1).corelibs-build'
    unset LD_LIBRARY_PATH && cd '$(1).corelibs-build' && '$(1)/$(glibc_SUBDIR)/configure' \
        --host='$(basename $(TARGET))' \
        --prefix='$(PREFIX)/$(TARGET)' \
        --enable-shared \
        --enable-static

    $(MAKE) -C '$(1).corelibs-build'
    unset LD_LIBRARY_PATH && $(MAKE) -C '$(1).corelibs-build' install

    # build mingw-w64-crt

    # build rest of gcc
    cd '$(1).build'
    $(MAKE) -C '$(1).build' -j '$(JOBS)' all-target-libgcc
    $(MAKE) -C '$(1).build' -j '$(JOBS)' all-target-libstdc++-v3
    $(MAKE) -C '$(1).build' -j 1 install-target-libgcc
    $(MAKE) -C '$(1).build' -j 1 install-target-libstdc++-v3

    # shared libgcc isn't installed to version-specific locations
    # so install correctly to avoid clobbering with multiple versions
    $(and $(BUILD_SHARED),
    $(MAKE) -C '$(1).build/$(TARGET)/libgcc' -j 1 \
        toolexecdir='$(PREFIX)/$(TARGET)/bin/gcc-$($(PKG)_VERSION)' \
        SHLIB_SLIBDIR_QUAL= \
        install-shared)

    if [ -f "$($(PKG)_LIBGCC_FOLDER)/libgcc.a" ]; then \
        ln -sf "$($(PKG)_LIBGCC_FOLDER)/libgcc.a" \
            "$($(PKG)_LIBGCC_FOLDER)/libgcc_s.a" \
    fi

    $($(PKG)_POST_BUILD)
endef

#$(PKG)_BUILD_x86_64-w64-mingw32 = $(subst @gcc-crt-config-opts@,--disable-lib32,$($(PKG)_BUILD_mingw-w64))
#$(PKG)_BUILD_i686-w64-mingw32   = $(subst @gcc-crt-config-opts@,--disable-lib64,$($(PKG)_BUILD_mingw-w64))

define $(PKG)_BUILD_$(BUILD)
    for f in c++ cpp g++ gcc gcov; do \
        ln -sf "`which $$f`" '$(PREFIX)/bin/$(TARGET)'-$$f ; \
    done
endef
