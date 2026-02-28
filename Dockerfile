FROM osrf/ros:humble-desktop-full

ENV DEBIAN_FRONTEND=noninteractive

# Install basic tools
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    lsb-release \
    gnupg2 \
    software-properties-common \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install MoveIt, ROS2 control, Gazebo GUI dependencies
RUN apt-get update && apt-get install -y \
    ros-humble-moveit \
    ros-humble-ros2-control \
    ros-humble-ros2-controllers \
    ros-humble-moveit-servo \
    ros-humble-moveit-visual-tools \
    ros-humble-gazebo-ros-pkgs \
    libx11-6 \
    libxext6 \
    libxrender1 \
    libxcb1 \
    libx11-xcb1 \
    libxcb-glx0 \
    libxkbcommon-x11-0 \
    libgl1-mesa-glx \
    libgl1-mesa-dri \
    mesa-utils \
    && rm -rf /var/lib/apt/lists/*

# Source ROS 2 automatically
RUN echo "source /opt/ros/humble/setup.bash" >> /root/.bashrc

# Set workspace
WORKDIR /root/ws

# Copy your ROS workspace into the container
COPY ./lcr /root/ws/lcr

# Update git submodules
RUN cd /root/ws/lcr/src/mirte-ros-packages && \
    git submodule update --init --recursive

# Refresh apt index for runtime container
RUN apt-get update

CMD ["bash"]