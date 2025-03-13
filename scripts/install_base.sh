#!/bin/bash
set -e

echo "Configurando timezone e pacotes base..."
echo 'Etc/UTC' > /etc/timezone && \
    ln -s /usr/share/zoneinfo/Etc/UTC /etc/localtime && \
    apt-get update && \
    apt-get install -y --no-install-recommends tzdata dirmngr gnupg lsb-release && \
    rm -rf /var/lib/apt/lists/*

