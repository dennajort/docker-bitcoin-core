# docker-bitcoin-core

Bitcoin core statically compiled in a docker container.

`docker pull dennajort/docker-bitcoin-core:latest`

This image has this volume:
- `/var/lib/bitcoin` this is configured via BITCOIN_DATA env variable

This image is based on `gcr.io/distroless/base-debian11` so it does not contain a shell
nor other softwares except the ones built for tor in order to reduce attack factor.
It is built with statically compiled libraries.
