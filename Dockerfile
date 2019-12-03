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
COPY ./Core3 .

# This is a hack to make the /app folder the root of it's own
# git repo. Without this section git will treat is as a submodule
# of swgemu-docker but will be missing the .git folder and fail all git commands
RUN rm .git
COPY .git/modules/Core3/. .git/
RUN sed -i 's/..\/..\/Core3\///' .git/modules/MMOCoreORB/utils/engine3/config && \
    sed -i 's/worktree.*//' .git/config && \
    sed -i 's/..\/.git\/modules\/Core3\//.git\//' MMOCoreORB/utils/engine3/.git

WORKDIR /app/MMOCoreORB
RUN make -j4

ADD https://github.com/krallin/tini/releases/download/v0.18.0/tini /usr/bin/tini
RUN chmod a+x /usr/bin/tini

COPY scripts /app/scripts
RUN ln -s /app/scripts/swgemu.sh /usr/bin/swgemu

WORKDIR /app/MMOCoreORB/bin

# tini is needed as core3 does not explicitly handle SIGTERM signals
ENTRYPOINT ["tini", "--"]
CMD ["swgemu", "start"]