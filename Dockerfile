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