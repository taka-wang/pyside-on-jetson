FROM nvcr.io/nvidia/l4t-tensorrt:r8.2.1-runtime
LABEL maintainer="taka@cmwang.net"

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y build-essential cmake python3-pip git libxml2-dev libxslt1-dev

RUN apt-get install -y '^libxcb.*-dev' libx11-xcb-dev libglu1-mesa-dev libxrender-dev libxi-dev libxkbcommon-dev libxkbcommon-x11-dev
RUN apt-get install -y libclang-dev libclang-9-dev libssl-dev libsdl2-dev libasound2 libxmu-dev libxi-dev freeglut3-dev libasound2-dev libjack-jackd2-dev libxrandr-dev

ENV LLVM_INSTALL_DIR=/usr/lib/llvm-10/
RUN pip3 install --upgrade pip setuptools && pip3 install packaging
RUN apt-get install -y ninja-build llvm-10 clang-10 libclang-10-dev g++-8 gcc-8 
RUN apt install -y bison build-essential clang flex gperf \
    libatspi2.0-dev libbluetooth-dev libclang-dev libcups2-dev libdrm-dev \
    libegl1-mesa-dev libfontconfig1-dev libfreetype6-dev \
    libgstreamer1.0-dev libhunspell-dev libnss3-dev \
    libpulse-dev libssl-dev libts-dev libx11-dev libx11-xcb-dev \
    libxcb-glx0-dev libxcb-icccm4-dev libxcb-image0-dev \
    libxcb-keysyms1-dev libxcb-randr0-dev libxcb-render-util0-dev \
    libxcb-shape0-dev libxcb-shm0-dev libxcb-sync-dev libxcb-util-dev \
    libxcb-xfixes0-dev libxcb-xinerama0-dev libxcb-xkb-dev libxcb1-dev \
    libxcomposite-dev libxcursor-dev libxdamage-dev libxext-dev \
    libxfixes-dev libxi-dev libxkbcommon-dev libxkbcommon-x11-dev \
    libxkbfile-dev libxrandr-dev libxrender-dev libxshmfence-dev \
    libxshmfence1 llvm ninja-build nodejs

WORKDIR /root/

RUN wget https://github.com/Kitware/CMake/releases/download/v3.24.1/cmake-3.24.1.tar.gz && \
    tar -zxvf cmake-3.24.1.tar.gz && \
    rm cmake-3.24.1.tar.gz && \
    cd cmake-3.24.1 && \
    ./bootstrap && \
    make && \
    make install && \
    cmake --version 

RUN wget http://master.qt.io/archive/qt/6.3/6.3.1/single/qt-everywhere-src-6.3.1.tar.xz && \
    tar -xpf qt-everywhere-src-6.3.1.tar.xz && \
    rm qt-everywhere-src-6.3.1.tar.xz 



RUN cd qt-everywhere-src-6.3.1 && \
    ./configure -opensource \
	-confirm-license \
	-nomake examples \
	-nomake tests \
	-xcb \
	-xcb-xlib \
	-bundled-xcb-xinput && \
    cmake --build .


RUN cd qt-everywhere-src-6.3.1 && make install

RUN git clone --recursive https://code.qt.io/pyside/pyside-setup && \
    cd pyside-setup && \
	git checkout 6.3.1 && \
    python3 setup.py build --qtpaths=/usr/local/Qt-6.3.1/bin/qtpaths --build-tests --ignore-git --parallel=4 

RUN cd pyside-setup && \
    python3 setup.py bdist_wheel \
    --parallel=16 --ignore-git --reuse-build --standalone --limited-api=yes \
    --qtpaths=/usr/local/Qt-6.3.1/bin/qtpaths
