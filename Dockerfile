FROM debian:bullseye as aria2

RUN apt-get update && apt-get install -y \
    build-essential \
    libgnutls28-dev \
    nettle-dev \
    libgmp-dev \
    libssh2-1-dev \
    libc-ares-dev \
    libxml2-dev \
    zlib1g-dev \
    libsqlite3-dev \
    pkg-config \
    libcppunit-dev \
    autoconf \
    automake \
    autotools-dev \
    autopoint \
    libtool \
    git

WORKDIR /opt

RUN git clone --recursive https://github.com/tatsuhiro-t/aria2.git

WORKDIR /opt/aria2

RUN git reset c546fa492c752d0594312ee1a2ac8bb4763c40f2

RUN sed -i 's/1, 16, /1, 128, /g' src/OptionHandlerFactory.cc

RUN autoreconf -i && \
   ./configure && \
   make && \
   make install

RUN rm -rf /opt/aria2

FROM debian:bullseye

COPY --from=aria2 /usr/local/bin/aria2c /usr/local/bin/aria2c
