# Mirte Master Lab Cleanup Docker Container
![Status](https://img.shields.io/badge/status-in%20progress-yellow)

This is a Docker Container package running `Ubuntu Jammy` with `ROS 2 Humble` and `Gazebo Classic`. 
> As the mirte ros packages have not (yet) been
updated to ROS 2 Jazzy or for use with Gazebo Harmonic / Fortress, this repository could have deprecated or out of date packages soon.

## Installation
> Docker engine *must* be installed for this to work properly 


1. Clone repository locally
    - For developers
    ```sh
    git clone https://github.com/machine0herald/Mirte_Lab_Clean-gz_docker
    ```
    - For contributors
    ```sh
    git remote add origin https://github.com/machine0herald/Mirte_Lab_Clean-gz_docker
    git pull origin main
    ```

2. Update submodules recursively
    ```sh
    git submodule update --init --recursive
    cd lcr
    ```

3. install dependencies for this mirte_lc then mirte-gazebo
    ```sh
    vcs import src/ < src/mirte_lc/sources.repos
    vcs import src/ < src/mirte-gazebo/sources.repos
    ```

4. update mirte_ros_packages submodule
    ```sh
    cd src/mirte-ros-packages && git submodule update --init --recursive
    ```

5. Configure display
    ```sh
    export DISPLAY=:0
    xhost +local:docker
    ```

6. Start docker engine 
    ```sh
    sudo systemctl start docker
    ```

> NOTE:  It is reccomended to use the vscode extensions instead of the following

7. Build the Docker container
    ```sh
    # Navigate to the directory containing the Dockerfile
    cd /path/to/ros2_humble_dev

    # Build the Docker image (tag it as 'mirte_labclean')
    docker build -t mirte_labclean .
    ```

8. Install mirte ros packages rosdeps and build
    ```sh
    rosdep install -y --from-paths src/ --ignore-src --rosdistro humble
    colcon build --symlink-install
    ```

## Docker Startup

1. Start docker engine 
    ```sh
    sudo systemctl start docker
    ```

> NOTE:  It is reccomended to use the vscode extensions instead of the following

2. Start docker container
    ```sh
    # Run the container interactively with GUI support
    docker run -it \
        --env="DISPLAY=$DISPLAY" \
        --env="QT_X11_NO_MITSHM=1" \
        --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
        --name mirte_labclean_container \
        mirte_labclean

    # Notes:
    # - --env="DISPLAY=$DISPLAY" tells the container which X server to use
    # - --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" gives access to your X11 socket
    # - You can exit without stopping using Ctrl+P Ctrl+Q
    # - To restart the container: docker start -ai mirte_labclean_container
    ```

3. Test ros2 and gazebo installations with gazebo gui
    ```sh
    gazebo
    ```
    in another terminal:
    ```sh
    ros_2_control --list-controllers
    ```


## Run the demo

1. Bring up Mirte master in empty gazebo world
    ```sh
    ros2 launch mirte_gazebo gazebo_mirte_master_empty.launch.xml
    ```

2. Start Labclean
    ```sh
    ros2 launch mirte_lc_labclean labclean.launch.py
    ```

