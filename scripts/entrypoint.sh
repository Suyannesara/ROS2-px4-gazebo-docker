#!/bin/bash
set -e

echo "Inicializando ambiente ROS2..."
source /opt/ros/$ROS_DISTRO/setup.bash
exec "$@"
