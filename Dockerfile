FROM swgemu:test

COPY scripts /app/scripts
RUN ln -s /app/scripts/swgemu.sh /usr/bin/swgemu

WORKDIR /app/MMOCoreORB/bin
RUN /app/scripts/run.sh