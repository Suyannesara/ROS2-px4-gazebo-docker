#!/bin/bash
set -e

echo "Instalando Micro XRCE-DDS Agent & Client..."
git clone https://github.com/eProsima/Micro-XRCE-DDS-Agent.git
cd Micro-XRCE-DDS-Agent
mkdir build && cd build
cmake ..
make
make install
ldconfig /usr/local/lib/
