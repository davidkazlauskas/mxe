FROM safelists_build_env:v1

RUN mkdir -p /mxe/tmprust/musldist
WORKDIR /mxe/tmprust/musldist

RUN wget http://www.musl-libc.org/releases/musl-1.1.10.tar.gz
RUN tar xvf musl-1.1.10.tar.gz


RUN cd musl-1.1.10 \
   && CC=/mxe/usr/bin/i686-pc-linux-gnu.static-gcc ./configure --target=i686-linux-musl \
   --disable-shared --prefix=/mxe/usr/i686-pc-linux-gnu.static \
   && make

#RUN rm -rf tmprust

# Build a static library version of OpenSSL using musl-libc.  This is
# needed by the popular Rust `hyper` crate.
#RUN VERS=1.0.2g && \
    #curl -O https://www.openssl.org/source/openssl-$VERS.tar.gz && \
    #tar xvzf openssl-$VERS.tar.gz && cd openssl-$VERS && \
    #env CC=musl-gcc ./config --prefix=/usr/local/musl && \
    #env C_INCLUDE_PATH=/usr/local/musl/include/ make depend && \
    #make && sudo make install && \
    #cd .. && rm -rf openssl-$VERS.tar.gz openssl-$VERS
#ENV OPENSSL_INCLUDE_DIR=/usr/local/musl/include/ \
    #DEP_OPENSSL_INCLUDE=/usr/local/musl/include/ \
    #OPENSSL_LIB_DIR=/usr/local/musl/lib/ \
    #OPENSSL_STATIC=1

