FROM ubuntu:16.04

RUN apt-get update
RUN apt-get install -y build-essential \
    libmysqlclient-dev \
    liblua5.3-dev \
    libdb5.3-dev \
    libssl-dev \
    cmake \
    git \
    default-jre

WORKDIR /app
COPY . .

WORKDIR /app/MMOCoreORB
RUN make -j8

ADD https://github.com/krallin/tini/releases/download/v0.18.0/tini /usr/bin/tini
RUN chmod a+x /usr/bin/tini

COPY scripts /app/scripts
RUN ln -s /app/scripts/swgemu.sh /usr/bin/swgemu

WORKDIR /app/MMOCoreORB/bin

# tini is needed as core3 does not explicitly handle SIGTERM signals
ENTRYPOINT ["tini", "--"]
CMD ["swgemu", "start"]