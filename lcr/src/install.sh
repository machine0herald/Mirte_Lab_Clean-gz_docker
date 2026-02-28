git clone https://github.com/MetroRobots/color_util.git
git clone https://github.com/mirte-robot/mirte-gazebo.git

vcs import src/ < src/mirte-gazebo/sources.repos
rosdep install -y --from-paths src/ --ignore-src --rosdistro humble

cd mirte-ros-packages && git submodule update --init --recursive && cd ..

apt-get update
rosdep install --from-paths src --ignore-src -r -y

colcon build
source install/setup.bash