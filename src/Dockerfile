# Set up initial golang:buster layer
FROM golang:buster as base
RUN apt-get update && \
  apt-get install --no-install-recommends --assume-yes ca-certificates \
  git make wget liblz4-tool aria2 && \
  apt-get clean

# Create build layer where stargaze and cosmovisor are built from source
FROM base as build
RUN git clone https://github.com/public-awesome/stargaze /root/stargaze
WORKDIR /root/stargaze
RUN git checkout v2.0.0
RUN make install

RUN git clone https://github.com/cosmos/cosmos-sdk /root/cosmos-sdk
WORKDIR /root/cosmos-sdk
RUN git checkout v0.42.9
WORKDIR /root/cosmos-sdk/cosmovisor
ENV HOME=/root
RUN make cosmovisor

# Set env variables for final image and copy built binaries over
FROM base as final
ENV DAEMON_NAME=starsd
ENV DAEMON_HOME=/root/.starsd
ENV DAEMON_ALLOW_DOWNLOAD_BINARIES=false
ENV DAEMON_LOG_BUFFER_SIZE=512
ENV DAEMON_RESTART_AFTER_UPGRADE=true
ENV UNSAFE_SKIP_BACKUP=true

COPY --from=build /go/bin/starsd /go/bin/starsd
COPY --from=build /root/cosmos-sdk/cosmovisor/cosmovisor /go/bin/cosmovisor

RUN mkdir -p ~/.starsd/cosmovisor/upgrades
RUN mkdir -p ~/.starsd/cosmovisor/genesis/bin
RUN cp /go/bin/starsd ~/.starsd/cosmovisor/genesis/bin
RUN mkdir -p ~/.starsd/config/
RUN mkdir -p ~/.starsd/data/
VOLUME [ "/root/.starsd/config/" ]
VOLUME [ "/root/.starsd/data/" ]
RUN ulimit -n 8192

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]