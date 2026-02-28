FROM osrf/ros:humble-desktop-full

ENV DEBIAN_FRONTEND=noninteractive

# Install basic tools
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    lsb-release \
    gnupg2 \
    software-properties-common \
    && rm -rf /var/lib/apt/lists/*

# Install MoveIt and ROS 2 control packages
RUN apt-get update && apt-get install -y \
    ros-humble-moveit \
    ros-humble-ros2-control \
    ros-humble-ros2-controllers \
    ros-humble-moveit-servo \
    ros-humble-moveit-visual-tools \
    ros-humble-gazebo-ros-pkgs \
    && rm -rf /var/lib/apt/lists/*

# Source ROS 2 automatically
RUN echo "source /opt/ros/humble/setup.bash" >> /root/.bashrc

WORKDIR /root/ws
CMD ["bash"]