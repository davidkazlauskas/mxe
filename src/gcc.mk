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

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://ftp.gnu.org/gnu/gcc/?C=M;O=D' | \
    $(SED) -n 's,.*<a href="gcc-\([0-9][^"]*\)/".*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_CONFIGURE
    # configure gcc
    mkdir -p '$(1).build'
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
        $(if $(SHARED_LIBGCC),--enable-shared="libgcc") \
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
    make -C "$(1)/$(linux-headers_SUBDIR)" headers_install ARCH=i386 INSTALL_HDR_PATH="$(PREFIX)/$(TARGET)"

    # build glibc headers
    $(call PREPARE_PKG_SOURCE,glibc,$(1))
    mkdir '$(1).headers-build'
    unset LD_LIBRARY_PATH && cd '$(1).headers-build' && '$(1)/$(glibc_SUBDIR)/configure' \
        --host='$(basename $(TARGET))' \
        --prefix='$(PREFIX)/$(TARGET)' \
        --with-headers='$(PREFIX)/$(TARGET)/include' \
        CC="gcc -m32" \
        CFLAGS="-Wno-error=attributes -O2 -march=i686" \
        libc_cv_forced_unwind=yes

    $(MAKE) -C '$(1).headers-build' install-headers
    $(MAKE) install-bootstrap-headers=yes -C '$(1).headers-build' install-headers

    # add sys-include
    cd '$(PREFIX)/$(TARGET)' && rm -f sys-include && ln -s include sys-include

    # make temporary fake stubs
    mkdir -p $(PREFIX)/$(TARGET)/include/gnu && touch $(PREFIX)/$(TARGET)/include/gnu/stubs.h

    # build standalone gcc
    $($(PKG)_CONFIGURE)
    $(MAKE) -C '$(1).build' -j '$(JOBS)' all-gcc
    $(MAKE) -C '$(1).build' -j 1 install-gcc

    # force correct 32 bit flags
    cp "$(PREFIX)/bin/$(TARGET)-gcc" "$(PREFIX)/bin/$(TARGET)-gcc-orig"
    cp "$(PREFIX)/bin/$(TARGET)-g++" "$(PREFIX)/bin/$(TARGET)-g++-orig"
    ( \
        echo '#!/bin/sh'; \
        echo ''; \
        echo '$(PREFIX)/bin/$(TARGET)-gcc-orig \
        -shared-libgcc -m32 -march=i686 "$$@"'; \
    ) > "$(PREFIX)/bin/$(TARGET)-gcc"
    ( \
        echo '#!/bin/sh'; \
        echo ''; \
        echo '$(PREFIX)/bin/$(TARGET)-g++-orig \
        -shared-libgcc -m32 -march=i686 "$$@"'; \
    ) > "$(PREFIX)/bin/$(TARGET)-g++"

    $(MAKE) -C '$(1).build' -j '$(JOBS)' all-target-libgcc
    $(MAKE) -C '$(1).build' -j 1 install-target-libgcc

    # build glibc
    mkdir '$(1).corelibs-build'
    unset LD_LIBRARY_PATH && cd '$(1).corelibs-build' && '$(1)/$(glibc_SUBDIR)/configure' \
        --host='$(basename $(TARGET))' \
        --prefix='$(PREFIX)/$(TARGET)' \
        --with-headers='$(PREFIX)/$(TARGET)/include' \
        --enable-shared \
        --enable-static \
        CC="$(PREFIX)/bin/$(TARGET)-gcc" \
        CFLAGS="-Wno-error=attributes -O2"

    $(MAKE) -C '$(1).corelibs-build'
    unset LD_LIBRARY_PATH && $(MAKE) -C '$(1).corelibs-build' install

    # build rest of gcc
    cd '$(1).build' && $(MAKE) clean
    $(eval SHARED_LIBGCC = "true")
    $($(PKG)_CONFIGURE)
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

	$(eval GCC_LIB_PATH=$(PREFIX)/lib/gcc/$(TARGET)/$($(PKG)_VERSION))

    if [ -f "$(GCC_LIB_PATH)/libgcc.a" ]; then \
        ln -sf "$(GCC_LIB_PATH)/libgcc.a" \
            "$(GCC_LIB_PATH)/libgcc_s.a"; \
    fi

    if [ -f "$(GCC_LIB_PATH)/libgcc_s.so" ]; then \
        ln -sf "$(GCC_LIB_PATH)/libgcc_s.so" \
            "$(GCC_LIB_PATH)/libgcc.so"; \
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
