FROM osrf/ros:humble-desktop

# Install additional ROS packages
RUN apt-get update && apt-get install -y \
    ros-humble-moveit \
    ros-humble-ros2-control \
    ros-humble-ros2-controllers \
    ros-humble-moveit-servo \
    ros-humble-moveit-visual-tools \
    ros-humble-ros-gz \
    && rm -rf /var/lib/apt/lists/*

# Source ROS automatically when container starts
RUN echo "source /opt/ros/humble/setup.bash" >> /root/.bashrc

WORKDIR /root/ws

CMD ["bash"]