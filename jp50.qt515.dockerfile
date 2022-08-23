FROM nvcr.io/nvidia/l4t-base:r35.1.0
LABEL maintainer="taka@cmwang.net"

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y build-essential cmake python3-pip git libxml2-dev libxslt1-dev

RUN apt-get install -y '^libxcb.*-dev' libx11-xcb-dev libglu1-mesa-dev libxrender-dev libxi-dev libxkbcommon-dev libxkbcommon-x11-dev
RUN apt-get install -y libclang-dev libclang-9-dev libssl-dev libsdl2-dev libasound2 libxmu-dev libxi-dev freeglut3-dev libasound2-dev libjack-jackd2-dev libxrandr-dev
RUN wget http://master.qt.io/archive/qt/5.15/5.15.2/submodules/qtbase-everywhere-src-5.15.2.tar.xz && \
    tar -xpf qtbase-everywhere-src-5.15.2.tar.xz && \
    rm qtbase-everywhere-src-5.15.2.tar.xz && \
    cd qtbase-everywhere-src-5.15.2 && \
    ./configure -opensource \
	-confirm-license \
	-nomake examples \
	-nomake tests \
	-xcb \
	-xcb-xlib \
	-bundled-xcb-xinput && \
    make -j12
RUN cd qtbase-everywhere-src-5.15.2 && make install

ENV LLVM_INSTALL_DIR=/usr/lib/llvm-9/
RUN apt-get install -y packaging
RUN cd /root/ && git clone git://code.qt.io/pyside/pyside-setup.git && \
	cd pyside-setup && \
	git checkout 5.15.2 && \
    sed -i -- "s/\${QtGui_GEN_DIR}\/qopengltimemonitor_wrapper.cpp/#\${QtGui_GEN_DIR}\/qopengltimemonitor_wrapper.cpp/g" ~/pyside-setup/sources/pyside2/PySide2/QtGui/CMakeLists.txt && \
    sed -i -- "s/\${QtGui_GEN_DIR}\/qopengltimerquery_wrapper.cpp/#\${QtGui_GEN_DIR}\/qopengltimerquery_wrapper.cpp/g" ~/pyside-setup/sources/pyside2/PySide2/QtGui/CMakeLists.txt && \
    python3 setup.py build --qmake=/usr/local/Qt-5.15.2/bin/qmake

RUN cd /root/pyside-setup && python3 setup.py --only-package bdist_wheel