FROM safelists_build_env_w32:v1

WORKDIR /
RUN mkdir -p templatious/templatious
RUN git clone https://github.com/davidkazlauskas/templatious.git templatious/templatious
RUN cd templatious/templatious && git reset --hard 5f2489970c87c2169371bae6c0269ffe44ca4ddb

ENV TEMPLATIOUS_DIR /templatious/

WORKDIR /mxe/
RUN cp /mxe/pkg/libsodium-1.0.6.tar.gz /mxe/
RUN tar xvf libsodium-1.0.6.tar.gz
WORKDIR /mxe/libsodium-1.0.6
RUN CC=/mxe/usr/bin/i686-w64-mingw32.static-gcc \
       ./configure --prefix=/mxe/usr/i686-w64-mingw32.static \
       --disable-shared \
       --build=x86_64-unknown-linux-gnu \
       --host=i686-w64-mingw32 \
       --target=i686-w64-mingw32

RUN make
RUN make install

RUN rm -rf /mxe/libsodium-1.0.6*

ADD safefiledownloader.dll /mxe/usr/i686-w64-mingw32.static/lib

WORKDIR /
