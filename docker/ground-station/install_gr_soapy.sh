apt-get install -y \
    libboost-dev \
    libboost-date-time-dev \
    libboost-filesystem-dev \
    libboost-program-options-dev \
    libboost-system-dev \
    libboost-thread-dev \
    libboost-regex-dev \
    libboost-test-dev \
    python3 \
    python3-six \
    python3-mako \
    python3-dev \
    swig \
    cmake \
    gcc \
    gnuradio-dev \
    libsoapysdr-dev \
    libconfig++-dev \
    libgmp-dev \
    liborc-0.4-0 \
    liborc-0.4-dev \
    liborc-0.4-dev-bin \
    git

git clone https://gitlab.com/librespacefoundation/gr-soapy
cd gr-soapy
mkdir build
cd build
cmake ..
make -j $(nproc --all)
sudo make install