FROM arm64v8/ubuntu:16.04

RUN apt-get update

# Install runtime dependencies
RUN apt-get install -qy \
    git curl build-essential g++ flex bison gperf ruby perl \
    libsqlite3-dev libfontconfig1-dev libicu-dev libfreetype6 libssl-dev \
    libpng-dev libjpeg-dev python libx11-dev libxext-dev \
    python python-pip
    #ttf-mscorefonts-installer

RUN git clone git://github.com/ariya/phantomjs.git /tmp/source && \
    cd /tmp/source && \
    git checkout 2.1.1 && \
    git submodule init && \
    git submodule update && \
    python build.py

RUN mv /tmp/source/bin/phantomjs /usr/local/bin

RUN pip install dumb-init

# Clean up
#RUN cd && \
#    apt-get purge --auto-remove -qy \
#    git curl build-essential g++ flex bison gperf ruby perl \
#    python python-pip && \
#    apt-get clean && \
#    rm -rf /tmp/* /var/lib/apt/lists/*

RUN useradd --system --uid 72379 -m --shell /usr/sbin/nologin phantomjs && \
    su phantomjs -s /bin/sh -c "phantomjs --version"

USER phantomjs

EXPOSE 8910

ENTRYPOINT ["dumb-init"]
CMD ["phantomjs"]
