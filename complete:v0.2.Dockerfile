# Etapa 1: Build para Micro-XRCE-DDS e PX4
FROM ubuntu:22.04 AS build

ARG DEBIAN_FRONTEND=noninteractive
WORKDIR /build

# Copiar scripts para o container
COPY scripts/ /scripts/
RUN chmod +x /scripts/*.sh

# Instalar pacotes necessários para build do PX4 e Micro-XRCE-DDS
RUN apt-get update && apt-get install -y --no-install-recommends \
    dirmngr gnupg lsb-release sudo wget curl \
    build-essential cmake git python3-pip ninja-build \
    && rm -rf /var/lib/apt/lists/*

# Construir o Micro-XRCE-DDS
RUN /scripts/install_micro_xrce_dds.sh

# Construir o PX4
RUN /scripts/install_px4.sh

# Etapa 2: Imagem final otimizada
FROM ubuntu:22.04 AS final

ARG DEBIAN_FRONTEND=noninteractive
WORKDIR /edra

# Copiar scripts para o container
COPY scripts/ /scripts/
RUN chmod +x /scripts/*.sh

# Instalar pacotes essenciais apenas para runtime
RUN apt-get update && apt-get install -y --no-install-recommends \
    dirmngr gnupg lsb-release sudo wget curl \
    && rm -rf /var/lib/apt/lists/*

# Configurar chave e repositório do ROS 2
RUN set -eux; \
    key='C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654'; \
    export GNUPGHOME="$(mktemp -d)"; \
    gpg --batch --keyserver keyserver.ubuntu.com --recv-keys "$key"; \
    mkdir -p /usr/share/keyrings; \
    gpg --batch --export "$key" > /usr/share/keyrings/ros2-latest-archive-keyring.gpg; \
    rm -rf "$GNUPGHOME"

RUN echo "deb [signed-by=/usr/share/keyrings/ros2-latest-archive-keyring.gpg] \
    http://packages.ros.org/ros2/ubuntu jammy main" > /etc/apt/sources.list.d/ros2-latest.list

# Instalar base e ROS 2
RUN /scripts/install_base.sh && \
    /scripts/install_ros2.sh && \
    /scripts/install_cmake.sh

# Copiar apenas os binários gerados na etapa de build
COPY --from=build /build/Micro-XRCE-DDS-Agent /opt/Micro-XRCE-DDS-Agent
COPY --from=build /build/PX4-Autopilot /opt/PX4-Autopilot

# Definir entrypoint
COPY scripts/entrypoint.sh /ros_entrypoint.sh
RUN chmod +x /ros_entrypoint.sh

ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]
