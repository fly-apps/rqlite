FROM debian:buster

RUN apt-get update && apt-get install --no-install-recommends -y \
    ca-certificates curl bash dnsutils \
    && apt autoremove -y

WORKDIR /opt

ARG RQLITE_VERSION=5.6.0

RUN curl -L https://github.com/rqlite/rqlite/releases/download/v$RQLITE_VERSION/rqlite-v$RQLITE_VERSION-linux-amd64.tar.gz \
    -o rqlite-linux-amd64.tar.gz \
    && tar xvfz rqlite-linux-amd64.tar.gz \
    && mv rqlite-v$RQLITE_VERSION-linux-amd64/* /usr/local/bin/

COPY entrypoint /entrypoint

ENTRYPOINT ["/entrypoint"]
CMD ["rqlited"]