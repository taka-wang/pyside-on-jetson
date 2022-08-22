FROM nvcr.io/nvidia/l4t-base:r32.6.1
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
	git checkout 5.9 && \
    sed -i -- "s/\${QtGui_GEN_DIR}\/qopengltimemonitor_wrapper.cpp/#\${QtGui_GEN_DIR}\/qopengltimemonitor_wrapper.cpp/g" ~/pyside-setup/sources/pyside2/PySide2/QtGui/CMakeLists.txt && \
    sed -i -- "s/\${QtGui_GEN_DIR}\/qopengltimerquery_wrapper.cpp/#\${QtGui_GEN_DIR}\/qopengltimerquery_wrapper.cpp/g" ~/pyside-setup/sources/pyside2/PySide2/QtGui/CMakeLists.txt && \
    python3 setup.py build

RUN cd /root/pyside-setup && python3 setup.py --only-package bdist_wheel
