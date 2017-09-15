FROM ubuntu:16.04 
MAINTAINER Rishi Ghan, rishi.ghan@gmail.com
# installs node 7.10.1 (npm v4.2.0) and phantomjs 2.1.1
# gpg keys listed at https://github.com/nodejs/node
RUN set -ex \
  && for key in \
    94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
    FD3A5288F042B6850C66B31F09FE44734EB7990E \
    71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
    DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
    C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
    B9AE9905FFD7803F25714661B63B535A4C206CA9 \
    56730D5401028683275BD23C23EFEFE93C4CFFFE \
  ; do \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
  done

ENV NPM_CONFIG_LOGLEVEL info
ENV NODE_VERSION 7.10.1
ENV PHANTOM_JS phantomjs-2.1.1-linux-x86_64 
RUN apt-get update && \
    apt-get install -qq -y build-essential curl tar git g++ python make wget \
    chrpath libssl-dev libxft-dev libfreetype6 libfreetype6-dev \
    libfontconfig1 libfontconfig1-dev && \
    wget https://github.com/Medium/phantomjs/releases/download/v2.1.1/$PHANTOM_JS.tar.bz2 && \
    tar xvjf $PHANTOM_JS.tar.bz2 && \
    mv $PHANTOM_JS /usr/local/share && \
    ln -sf /usr/local/share/$PHANTOM_JS/bin/phantomjs /usr/bin && \
    phantomjs --version 
RUN curl -SLO "https://nodejs.org/download/release/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz" \
  && curl -SLO "https://nodejs.org/download/release/v$NODE_VERSION/SHASUMS256.txt.asc" \
  && gpg --verify SHASUMS256.txt.asc \
  && grep " node-v$NODE_VERSION-linux-x64.tar.gz\$" SHASUMS256.txt.asc | sha256sum -c - \
  && tar -xzf "node-v$NODE_VERSION-linux-x64.tar.gz" -C /usr/local --strip-components=1 \
  && rm "node-v$NODE_VERSION-linux-x64.tar.gz" SHASUMS256.txt.asc

CMD node -v

