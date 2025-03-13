FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive

WORKDIR /edra

# Copiar scripts para o container
COPY scripts/ /scripts/
RUN chmod +x /scripts/*.sh

# install packages
RUN apt-get update && apt-get install -q -y --no-install-recommends \
    dirmngr \
    gnupg \
    lsb-release \
    && rm -rf /var/lib/apt/lists/*

# setup keys
RUN set -eux; \
    key='C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654'; \
    export GNUPGHOME="$(mktemp -d)"; \
    gpg --batch --keyserver keyserver.ubuntu.com --recv-keys "$key"; \
    mkdir -p /usr/share/keyrings; \
    gpg --batch --export "$key" > /usr/share/keyrings/ros2-latest-archive-keyring.gpg; \
    gpgconf --kill all; \
    rm -rf "$GNUPGHOME"

# setup sources.list
RUN echo "deb [ signed-by=/usr/share/keyrings/ros2-latest-archive-keyring.gpg ] http://packages.ros.org/ros2/ubuntu jammy main" > /etc/apt/sources.list.d/ros2-latest.list


# Executar as instalações separadamente para otimizar cache
RUN /scripts/install_base.sh
RUN /scripts/install_ros2.sh
RUN /scripts/install_cmake.sh
RUN /scripts/install_micro_xrce_dds.sh
RUN /scripts/install_px4.sh

# Definir entrypoint
COPY scripts/entrypoint.sh /ros_entrypoint.sh
RUN chmod +x /ros_entrypoint.sh

ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]