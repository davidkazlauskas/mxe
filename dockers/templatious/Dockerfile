FROM intermediate_rust_musl:v1

WORKDIR /
RUN mkdir -p templatious/templatious
RUN git clone https://github.com/davidkazlauskas/templatious.git templatious/templatious
RUN cd templatious/templatious && git reset --hard 5f2489970c87c2169371bae6c0269ffe44ca4ddb

ENV TEMPLATIOUS_DIR /templatious/
