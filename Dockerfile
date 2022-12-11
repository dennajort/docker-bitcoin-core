FROM debian:11 as build

WORKDIR /build

# TINI
ARG TINI_VERSION=0.19.0
ADD https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini /build/out/tini
RUN chmod +x /build/out/tini

RUN apt-get update && apt-get install -y build-essential libtool autotools-dev automake pkg-config bsdmainutils python3 curl bison flex

# BITCOIN-CORE
ARG BITCOIN_VERSION
ADD https://bitcoincore.org/bin/bitcoin-core-${BITCOIN_VERSION}/bitcoin-${BITCOIN_VERSION}.tar.gz .
RUN tar xzf bitcoin-${BITCOIN_VERSION}.tar.gz

RUN cd bitcoin-${BITCOIN_VERSION}/depends && make NO_QT=1 NO_QR=1 HOST=x86_64-pc-linux-gnu

RUN cd bitcoin-${BITCOIN_VERSION} && \
    ./autogen.sh && \
    CONFIG_SITE=$PWD/depends/x86_64-pc-linux-gnu/share/config.site LDFLAGS="-static-libgcc -static-libstdc++" ./configure \
    --prefix= --disable-man --with-gui=no --with-libs=no --disable-bench --disable-tests  \
    && make && make DESTDIR=/build/out install

RUN mkdir -p /build/out/var/lib/bitcoin

# Build output image
FROM gcr.io/distroless/base-debian11

COPY --from=build /build/out /

ENV BITCOIN_DATA=/var/lib/bitcoin
VOLUME /var/lib/bitcoin
EXPOSE 8332 8333 18332 18333 18443 18444 38333 38332

ENTRYPOINT ["/tini", "--", "/bin/bitcoind"]
