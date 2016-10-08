FROM safelists_build_env:v1

RUN apt-get update && apt-get install -y curl

ENV PREFIX=/mxe/usr/i686-pc-linux-gnu.static

COPY rust-1.11.0.tar.gz /mxe/pkg/

RUN mkdir -p /mxe/tmprust

WORKDIR /mxe/tmprust
RUN tar xf /mxe/pkg/rust-1.11.0.tar.gz
WORKDIR /mxe/tmprust/rust-1.11.0

RUN ./configure \
    --build=x86_64-unknown-linux-gnu \
    --host=x86_64-unknown-linux-gnu \
    --target=i686-unknown-linux-gnu \
    --prefix=$PREFIX

RUN make; exit 0
RUN make install

WORKDIR /mxe/tmprust
RUN git clone --progress --recursive https://github.com/rust-lang/cargo.git

WORKDIR /mxe/tmprust/cargo
# release 0.13.0
RUN git reset --hard 109cb7c33
RUN ./configure --prefix=$PREFIX \
    --local-rust-root=$PREFIX
RUN make
RUN make install

WORKDIR /mxe/
RUN rm -rf tmprust
