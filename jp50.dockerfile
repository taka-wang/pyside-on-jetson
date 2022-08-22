FROM nvcr.io/nvidia/l4t-base:r35.1.0
LABEL maintainer="taka@cmwang.net"

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y build-essential cmake python3-pip git libxml2-dev libxslt1-dev

RUN apt-get install -y libclang-dev qt5-default qtscript5-dev libssl-dev qttools5-dev \
    qttools5-dev-tools qtmultimedia5-dev libqt5svg5-dev libqt5webkit5-dev libsdl2-dev \
    libasound2 libxmu-dev libxi-dev freeglut3-dev libasound2-dev libjack-jackd2-dev \
    libxrandr-dev libqt5xmlpatterns5-dev libqt5xmlpatterns5 libqt5xmlpatterns5-dev \
    qtdeclarative5-private-dev qtbase5-private-dev qttools5-private-dev \
    qtwebengine5-private-dev libclang-9-dev

ENV LLVM_INSTALL_DIR=/usr/lib/llvm-9/

RUN cd /root/ && git clone git://code.qt.io/pyside/pyside-setup.git && \
	cd pyside-setup && \
	qmake --version && \
	git checkout 5.12 && \
    sed -i -- "s/3.7/3.8/g" ~/pyside-setup/build_scripts/config.py && \
    python3 setup.py build

RUN python3 setup.py --only-package bdist_wheel && \
    python3 setup.py install