apt-get install -y \
    libboost-dev \
    libitpp-dev \
    libboost-date-time-dev \
    libboost-filesystem-dev \
    libboost-program-options-dev \
    libboost-system-dev \
    libboost-thread-dev \
    libboost-regex-dev \
    libboost-test-dev \
    swig \
    cmake \
    build-essential \
    pkg-config \
    gnuradio-dev \
    libconfig++-dev \
    libgmp-dev \
    liborc-0.4-0 \
    liborc-0.4-dev \
    liborc-0.4-dev-bin \
    nlohmann-json3-dev \
    libpng++-dev \
    libvorbis-dev \
    git

git clone https://gitlab.com/librespacefoundation/satnogs/gr-satnogs.git
cd gr-satnogs
mkdir build
cd build
cmake ..
make -j $(nproc --all)
make install