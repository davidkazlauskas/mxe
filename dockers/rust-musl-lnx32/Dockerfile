FROM safelists_build_env:v1

RUN apt-get update && apt-get install -y curl

RUN mkdir -p /mxe/tmprust/musldist
WORKDIR /mxe/tmprust/musldist

RUN wget http://www.musl-libc.org/releases/musl-1.1.10.tar.gz
RUN tar xvf musl-1.1.10.tar.gz

ENV PREFIX=/mxe/usr/i686-pc-linux-gnu.static

RUN cd musl-1.1.10 \
   && CC=/mxe/usr/bin/i686-pc-linux-gnu.static-gcc ./configure --target=i686-linux-musl \
   --disable-shared --prefix=$PREFIX \
   && make && make install

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
RUN cmake -DLLVM_PATH=../../.. -DLIBUNWIND_ENABLE_SHARED=0 .. && make
RUN cp lib/libunwind.a $PREFIX/lib/

WORKDIR /mxe/tmprust
RUN git clone --progress https://github.com/rust-lang/rust.git
# reset to release 1.11
RUN cd rust && git reset --hard 9b21dcd6a89f38e8ceccb2ede8c9027cb409f6e3
RUN cd rust && git submodule update --init --recursive
WORKDIR /mxe/tmprust/rust
    CXX=/mxe/usr/bin/i686-pc-linux-gnu.static-g++ \
    ./configure --default-linker=/mxe/usr/bin/i686-pc-linux-gnu.static-gcc \
    --build=i686-unknown-linux-musl \
    --host=i686-unknown-linux-musl \
    --target=i686-unknown-linux-musl \
    --default-ar=/mxe/usr/bin/i686-pc-linux-gnu.static-ar \
    --musl-root=$PREFIX --prefix=$PREFIX
RUN make
RUN make install

RUN rm -rf tmprust
