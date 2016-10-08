FROM safelists_build_env:v1

RUN apt-get update && apt-get install -y curl

RUN mkdir -p /mxe/tmprust/musldist
WORKDIR /mxe/tmprust/musldist

RUN wget http://www.musl-libc.org/releases/musl-1.1.10.tar.gz
RUN tar xvf musl-1.1.10.tar.gz

ENV PREFIX=/mxe/usr/i686-pc-linux-gnu.static
ENV MUSL_PREFIX=/mxe/usr/i686-unknown-linux-musl

RUN mkdir $MUSL_PREFIX

RUN cd musl-1.1.10 && \
    CC=/mxe/usr/bin/i686-pc-linux-gnu.static-gcc ./configure --target=i686-linux-musl \
    --disable-shared --prefix=$MUSL_PREFIX
RUN cd musl-1.1.10 && \
    CC=/mxe/usr/bin/i686-pc-linux-gnu.static-gcc make && make install

RUN sed -i -e '2iexport REALGCC=/mxe/usr/bin/i686-pc-linux-gnu.static-gcc' $MUSL_PREFIX/bin/musl-gcc

RUN rm -rf /mxe/tmprust/musldist

WORKDIR /mxe/tmprust
RUN wget http://llvm.org/releases/3.7.0/llvm-3.7.0.src.tar.xz
RUN tar xf llvm-3.7.0.src.tar.xz
WORKDIR /mxe/tmprust/llvm-3.7.0.src/projects
RUN wget http://llvm.org/releases/3.7.0/libunwind-3.7.0.src.tar.xz
RUN tar xf libunwind-3.7.0.src.tar.xz
RUN mv libunwind-3.7.0.src libunwind
RUN mkdir libunwind/build
WORKDIR /mxe/tmprust/llvm-3.7.0.src/projects/libunwind/build
RUN cmake -DCMAKE_TOOLCHAIN_FILE=/mxe/usr/i686-pc-linux-gnu.static/share/cmake/mxe-conf.cmake \
    -DLLVM_PATH=../../.. -DLIBUNWIND_ENABLE_SHARED=0 .. && make
RUN cp lib/libunwind.a $MUSL_PREFIX/lib/

WORKDIR /mxe/tmprust
RUN git clone --progress https://github.com/rust-lang/rust.git
# reset to release 1.11
RUN cd rust && git reset --hard 9b21dcd6a89f38e8ceccb2ede8c9027cb409f6e3
RUN cd rust && git submodule update --init --recursive
WORKDIR /mxe/tmprust/rust
# disable c++ check because it fails

RUN ./configure \
    --build=x86_64-unknown-linux-gnu \
    --host=x86_64-unknown-linux-gnu \
    --target=i686-unknown-linux-musl \
    --musl-root=$MUSL_PREFIX \
    --prefix=$MUSL_PREFIX

RUN sed -i 's/#include/\/\/#include/g' src/compiler-rt/cmake/config-ix.cmake
RUN make; exit 0
RUN CXX=/mxe/usr/bin/i686-pc-linux-gnu.static-g++ make
RUN make install

WORKDIR /mxe/tmprust
RUN git clone --progress --recursive https://github.com/rust-lang/cargo.git

WORKDIR /mxe/tmprust/cargo
# release 0.13.0
RUN git reset --hard 109cb7c33
RUN ./configure --prefix=$MUSL_PREFIX \
    --local-rust-root=$MUSL_PREFIX
RUN make
RUN make install

WORKDIR /mxe/
RUN rm -rf tmprust
