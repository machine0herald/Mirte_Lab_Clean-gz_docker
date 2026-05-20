FROM osrf/ros:humble-desktop-full

ENV DEBIAN_FRONTEND=noninteractive

# Core tools + ROS dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3-pip \
    git wget curl lsb-release gnupg2 software-properties-common \
    ros-humble-moveit \
    ros-humble-ros2-control \
    ros-humble-foxglove-bridge \
    ros-humble-ros2-controllers \
    ros-humble-moveit-servo \
    ros-humble-moveit-visual-tools \
    ros-humble-gazebo-ros-pkgs \
    ros-humble-slam-toolbox \
    ros-humble-cv-bridge \
    ros-humble-octomap-server \
    ros-humble-topic-tools \
    ros-humble-joint-state-publisher \
    ros-humble-joint-state-publisher-gui \
    ros-humble-navigation2 \
    ros-humble-rosbridge-server \
    ros-humble-tf-transformations \
    ros-humble-usb-cam \
    ros-humble-web-video-server \
    ros-humble-rosbag2-storage-mcap \
    libgpiod-dev \
    libpcl-dev \
    ros-humble-pcl-ros \
    libx11-6 libxext6 libxrender1 libxcb1 libx11-xcb1 \
    libxcb-glx0 libxkbcommon-x11-0 \
    libgl1-mesa-glx libgl1-mesa-dri mesa-utils \
    && rm -rf /var/lib/apt/lists/*

# Python tools
RUN pip install --force-reinstall "numpy==2.2.6" "pandas==2.3.3"
RUN pip3 install shapely
RUN pip3 install trajgenpy
RUN pip3 install geojson
RUN pip3 install scikit-image
RUN pip3 install scipy
RUN pip3 install matplotlib
RUN pip3 install opencv-python

# Workspace (IMPORTANT: must match devcontainer)
WORKDIR /workspaces/lcr

# Copy workspace
COPY ./lcr /workspaces/lcr

# Init submodules safely
RUN git -C /workspaces/lcr/src/mirte-ros-packages \
    submodule update --init --recursive || true

# ROS sourcing
RUN echo "source /opt/ros/humble/setup.bash" >> /root/.bashrc
RUN echo "source /workspaces/lcr/install/setup.bash" >> /root/.bashrc

CMD ["bash"]