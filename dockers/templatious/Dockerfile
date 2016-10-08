FROM intermediate_rust_musl:v1

WORKDIR /
RUN mkdir -p templatious/templatious
RUN git clone https://github.com/davidkazlauskas/templatious.git templatious/templatious
RUN cd templatious/templatious && git reset --hard 5f2489970c87c2169371bae6c0269ffe44ca4ddb

ENV TEMPLATIOUS_DIR /templatious/

WORKDIR /mxe/
RUN cp /mxe/pkg/libsodium-1.0.6.tar.gz /mxe/
RUN tar xvf libsodium-1.0.6.tar.gz
WORKDIR /mxe/libsodium-1.0.6
RUN CC=/mxe/usr/i686-unknown-linux-musl/bin/musl-gcc \
       ./configure --prefix=/mxe/usr/i686-unknown-linux-musl \
       --disable-shared \
       --build=x86_64-unknown-linux-gnu \
       --host=x86_64-unknown-linux-gnu \
       --host=i686-unknown-linux-musl

RUN make
RUN make install

RUN rm -rf /mxe/libsodium-1.0.6*

WORKDIR /
