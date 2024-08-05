# Copyright 2019 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# FROM gcr.io/clusterfuzz-images/base

# Build from the Ubuntu 20.04
FROM ubuntu:16.04 as xenial
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y \
    #   libcurl3-gnutls \
      libffi6 \
      libnettle6 \
      libssl1.0.0

FROM ubuntu:20.04

RUN mkdir /work
WORKDIR /work

ENV DEBIAN_FRONTEND=noninteractive

# Install common dependencies
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get autoremove -y && \
    apt-get install -y \
        apt-transport-https \
        build-essential \
        curl \
        gdb \
        iproute2 \
        libbz2-dev \
        libcurl4-openssl-dev \
        libffi-dev \
        libgdbm-dev \
        libidn11 \
        liblzma-dev \
        libncurses5-dev \
        libncursesw5 \
        libnss3-dev \
        libreadline-dev \
        libsqlite3-dev \
        libssl-dev \
        libtinfo5 \
        locales \
        lsb-release \
        net-tools \
        psmisc \
        socat \
        sudo \
        unzip \
        util-linux \
        wget \
        zip \
        zlib1g-dev \
        vim \ 
        git \ 
        nfs-common \
        autofs

# Install clusterfuzz
COPY --from=xenial \
    /lib/x86_64-linux-gnu/libcrypto.so.1.0.0 \
    /lib/x86_64-linux-gnu/libssl.so.1.0.0 \
    /lib/x86_64-linux-gnu/
COPY --from=xenial \
    # /usr/lib/x86_64-linux-gnu/libcurl-gnutls.so.* \
    /usr/lib/x86_64-linux-gnu/libffi.so.6.* \
    /usr/lib/x86_64-linux-gnu/libnettle.so.* \
    /usr/lib/x86_64-linux-gnu/

# Install patchelf.
RUN curl -sS https://releases.nixos.org/patchelf/patchelf-0.9/patchelf-0.9.tar.bz2 | tar -C /tmp -xj && \
    cd /tmp/patchelf-*/ && \
    ./configure --prefix=/usr && \
    make install

# Install Python 3.7
RUN curl -sS https://www.python.org/ftp/python/3.7.7/Python-3.7.7.tgz | tar -C /tmp -xzv && \
    cd /tmp/Python-3.7.7 && \
    ./configure --enable-optimizations --enable-loadable-sqlite-extensions && make altinstall && \
    rm -rf /tmp/Python-3.7.7
RUN pip3.7 install pipenv

# Install Golang
RUN curl -L -O https://go.dev/dl/go1.22.5.linux-amd64.tar.gz
RUN tar -C /usr/local -xzf go1.22.5.linux-amd64.tar.gz
RUN echo "export PATH=\$PATH:/usr/local/go/bin" >> ~/.bashrc

# Install Google Cloud SDK
# RUN echo "deb https://packages.cloud.google.com/apt cloud-sdk main" \
#     | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
#     curl https://packages.cloud.google.com/apt/doc/apt-key.gpg \
#     | apt-key add - && \
#     apt-get update -y && \
#     apt-get install -y google-cloud-sdk

# Set up google-fluentd
# We ignore errors in install-logging-agent.sh as it always fails to start
# after installation without a metadata server.
# RUN curl -sSO https://dl.google.com/cloudagents/install-logging-agent.sh && \
#     bash install-logging-agent.sh || true && \
#     sed -i 's/flush_interval 5s/flush_interval 60s/' /etc/google-fluentd/google-fluentd.confpw
# COPY clusterfuzz-fluentd.conf /etc/google-fluentd/config.d/clusterfuzz.conf

# Common environment variables.
ENV USER=root
ENV INSTALL_DIRECTORY=/work
ENV BOT_TMPDIR=$INSTALL_DIRECTORY/tmp
ENV ROOT_DIR=$INSTALL_DIRECTORY/clusterfuzz
ENV UPDATE_WEB_TESTS=False
ENV PYTHONPATH=$INSTALL_DIRECTORY/clusterfuzz/src
ENV RUN_CMD="python3.7 $ROOT_DIR/src/python/bot/startup/run.py"

# Git config
RUN git config --global user.name "acorn421"
RUN git config --global user.email "acorn421@gmail.com"

# Install clusterfuzz
RUN cd /work/ && \
    git clone https://github.com/acorn421/clusterfuzz.git && \
    cd clusterfuzz && \
    git pull && \
    # git checkout tags/v2.6.0 && \
    PYTHON=python3.7 ./local/install_deps.bash

# Passwordless sudo (needed for AFL launcher).
RUN groupadd nopwsudo && \
    echo "%nopwsudo ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/mysudoers

# VOLUME $INSTALL_DIRECTORY
WORKDIR $INSTALL_DIRECTORY
    
ENV locale-gen=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV PYTHONIOENCODING=UTF-8

# Install GS dependencies
# Setup TinyGS

# Setup SatNOGS
COPY install_gnuradio.sh install_gr_satnogs.sh install_gr_soapy.sh /work/

RUN chmod a+x /work/install_gnuradio.sh /work/install_gr_satnogs.sh /work/install_gr_soapy.sh
RUN /work/install_gnuradio.sh && \
    /work/install_gr_satnogs.sh && \
    /work/install_gr_soapy.sh

# COPY setup_nfs.sh /work/
COPY setup_common.sh setup_clusterfuzz.sh start_clusterfuzz.sh start.sh /work/
RUN chmod a+x /work/setup_common.sh /work/setup_clusterfuzz.sh /work/start_clusterfuzz.sh /work/start.sh

CMD ["bash", "-ex", "/work/start.sh"]