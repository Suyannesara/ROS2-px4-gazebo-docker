#!/bin/bash
set -e

echo "Instalando CMake 3.24.1..."
wget https://github.com/Kitware/CMake/releases/download/v3.24.1/cmake-3.24.1-Linux-x86_64.sh \
    -q -O /tmp/cmake-install.sh
chmod +x /tmp/cmake-install.sh
mkdir /opt/cmake-3.24.1
/tmp/cmake-install.sh --skip-license --prefix=/opt/cmake-3.24.1
rm /tmp/cmake-install.sh
ln -s /opt/cmake-3.24.1/bin/* /usr/local/bin
