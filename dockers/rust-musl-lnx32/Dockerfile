FROM safelists_build_env:v1

RUN apt-get update && apt-get install -y curl

ENV PREFIX=/mxe/usr/i686-pc-linux-gnu.static

COPY rust-1.11.0.tar.gz /mxe/pkg/

RUN mkdir -p /mxe/tmprust

WORKDIR /mxe/tmprust
RUN tar xf /mxe/pkg/rust-1.11.0.tar.gz
WORKDIR /mxe/tmprust/rust-1.11.0

RUN sed -i 's|CC_i686-unknown-linux-gnu=$(CC)|CC_i686-unknown-linux-gnu=/mxe/usr/bin/i686-pc-linux-gnu.static-gcc|g' \
        mk/cfg/i686-unknown-linux-gnu.mk
RUN sed -i 's|CXX_i686-unknown-linux-gnu=$(CXX)|CXX_i686-unknown-linux-gnu=/mxe/usr/bin/i686-pc-linux-gnu.static-g++|g' \
        mk/cfg/i686-unknown-linux-gnu.mk
RUN sed -i 's|CPP_i686-unknown-linux-gnu=$(CPP)|CPP_i686-unknown-linux-gnu=/mxe/usr/bin/i686-pc-linux-gnu.static-g++|g' \
        mk/cfg/i686-unknown-linux-gnu.mk
RUN sed -i 's|AR_i686-unknown-linux-gnu=$(AR)|AR_i686-unknown-linux-gnu=/mxe/usr/bin/i686-pc-linux-gnu.static-ar|g' \
        mk/cfg/i686-unknown-linux-gnu.mk

RUN ./configure \
    --build=x86_64-unknown-linux-gnu \
    --host=x86_64-unknown-linux-gnu \
    --target=i686-unknown-linux-gnu \
    --prefix=$PREFIX

RUN make; exit 0
RUN make install

WORKDIR /mxe/
# TODO: rebuild mxe with this fix
RUN sed -i 's|,linux-x32,|,linux-generic32,|' src/openssl.mk
RUN make openssl

WORKDIR /mxe/tmprust
RUN git clone --progress --recursive https://github.com/rust-lang/cargo.git

WORKDIR /mxe/tmprust/cargo

# release 0.13.0
RUN git reset --hard 109cb7c33
RUN ./configure --prefix=$PREFIX \
    --build=x86_64-unknown-linux-gnu \
    --host=x86_64-unknown-linux-gnu \
    --target=x86_64-unknown-linux-gnu \
    --local-rust-root=$PREFIX

# hax hax hax
RUN sed -i 's|$(CFG_PYTHON) $(S)src/etc/dl-snapshot.py|LD_LIBRARY_PATH="" DYLD_LIBRARY_PATH="" $(CFG_PYTHON) $(S)src/etc/dl-snapshot.py|g' Makefile
RUN sed -i 's|"curl", "-o"|"curl", "-k", "-o"|' src/etc/download.py

RUN make
RUN make install

WORKDIR /mxe/
RUN rm -rf tmprust
