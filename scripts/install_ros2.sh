#!/bin/bash
set -e

echo "Instalando ROS2 Humble..."
export ROS_DISTRO=humble

apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    git \
    sudo \
    wget \
    python3-pip \
    python3-colcon-common-extensions \
    python3-colcon-mixin \
    python3-rosdep python3-vcstool && \
    rm -rf /var/lib/apt/lists/*

rosdep init && rosdep update --rosdistro $ROS_DISTRO

colcon mixin add default https://raw.githubusercontent.com/colcon/colcon-mixin-repository/master/index.yaml
colcon mixin update
colcon metadata add default https://raw.githubusercontent.com/colcon/colcon-metadata-repository/master/index.yaml
colcon metadata update

apt-get update && apt-get install -y --no-install-recommends ros-${ROS_DISTRO}-ros-base && \
    rm -rf /var/lib/apt/lists/*
