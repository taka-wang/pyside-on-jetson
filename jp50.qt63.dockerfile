FROM nvcr.io/nvidia/l4t-base:r35.1.0
LABEL maintainer="taka@cmwang.net"

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y build-essential cmake python3-pip git libxml2-dev libxslt1-dev

RUN apt-get install -y '^libxcb.*-dev' libx11-xcb-dev libglu1-mesa-dev libxrender-dev libxi-dev libxkbcommon-dev libxkbcommon-x11-dev
RUN apt-get install -y libclang-dev libclang-9-dev libssl-dev libsdl2-dev libasound2 libxmu-dev libxi-dev freeglut3-dev libasound2-dev libjack-jackd2-dev libxrandr-dev
RUN wget http://master.qt.io/archive/qt/6.3/6.3.1/single/qt-everywhere-src-6.3.1.tar.xz && \
    tar -xpf qt-everywhere-src-6.3.1.tar.xz && \
    rm qt-everywhere-src-6.3.1.tar.xz && \
    cd qtbase-everywhere-src-6.3.1 && \
    ./configure -opensource \
	-confirm-license \
	-nomake examples \
	-nomake tests \
	-xcb \
	-xcb-xlib \
	-bundled-xcb-xinput && \
    make -j12
RUN cd qtbase-everywhere-src-6.3.1 && make install