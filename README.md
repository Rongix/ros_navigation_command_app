# ros_command_app
Application for controlling ROS robot with voice commands, sending goals on map or remote controll with virtual joystick
29.03.2020 

Please note that I made this app as a beginner (~29.03.2020), there are some mistakes and bad practices that should be changed, architecture / state management is also not great.

Check out youtube video showcasing app (PL + ENG subtitles):

[![YouTube video here](https://img.youtube.com/vi/RIz-qJ3_qvo/hqdefault.jpg)](https://www.youtube.com/watch?v=RIz-qJ3_qvo "YouTube video here")

### Map page
You can move robot between points which are created fter clicking on the fab. 

https://github.com/Rongix/ros_navigation_command_app

<img src="https://github.com/Rongix/ros_navigation_command_app/blob/main/Screenshot_20200825-155431.jpg" width="75%" height="75%"> <img src="https://github.com/Rongix/ros_navigation_command_app/blob/main/Screenshot_20200825-155355.jpg" width="17.8%" height="17.8%"> 

### Controller page
<img src="https://github.com/Rongix/ros_navigation_command_app/blob/main/Screenshot_20200825-152332.jpg"  width="75%" height="75%">  <img src="https://github.com/Rongix/ros_navigation_command_app/blob/main/Screenshot_20200825-152025.jpg" width="17.8%" height="17.8%"> 

### Chat page
Chat page provides communication with Dialogflow Agent.

<img src="https://github.com/Rongix/ros_navigation_command_app/blob/main/Screenshot_20200824-180256.jpg" width="20%" height="20%"> <img src="https://github.com/Rongix/ros_navigation_command_app/blob/main/Screenshot_20200824-180154.jpg" width="20%" height="20%">    

### Internatiolization & language support
~~This app is not internationalized, there are some UI hardcoded strings in polish, sorry for any inconvenience! It uses polish dialogflow intents so it may be tricky to get it running flawlessly~~.
This app has english and polish versions (no dialogflow agent included)

## Getting started:
You need to have ROS installed. App was tested with Turtlebot3 Waffle Pi in the simulation environment, althought it can work with any robot. You can quickly set topics and configurate ROS in the app settings. 

This project is a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Getting Started

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Prerequisites

- You don't need real robot to run app and navigate.
- [ROS Melodic](http://wiki.ros.org/melodic) - Ubuntu 18.04 / [ROS Kinetic](http://wiki.ros.org/kinetic) - Ubuntu 16.04)
- [Flutter](https://flutter.dev/docs/get-started/install).
- [Node.js](https://nodejs.org/en/) for interactive map. 

## Installation
### Installation of ROS

ROS kinetic: [please follow instruction](http://emanual.robotis.com/docs/en/platform/turtlebot3/pc_setup/)
ROS Melodic: Instruction for Ubuntu 18.04 below:

1. Following step will update your system and install ROS-Melodic-dekstop-full version. It will also create few aliases and source ROS-melodic environment in your .bashrc, and create catkin_ws folder in your root directory.
```
sudo apt update
sudo apt upgrade -y
wget https://raw.githubusercontent.com/ROBOTIS-GIT/robotis_tools/master/install_ros_melodic.sh && chmod 755 ./install_ros_melodic.sh && bash ./install_ros_melodic.sh
```
2. Install dependencies.
```
sudo apt install ros-melodic-joy ros-melodic-teleop-twist-joy ros-melodic-teleop-twist-keyboard ros-melodic-laser-proc ros-melodic-rgbd-launch ros-melodic-depthimage-to-laserscan ros-melodic-rosserial-arduino ros-melodic-rosserial-python ros-melodic-rosserial-server ros-melodic-rosserial-client ros-melodic-rosserial-msgs ros-melodic-amcl ros-melodic-map-server ros-melodic-move-base ros-melodic-urdf ros-melodic-xacro ros-melodic-compressed-image-transport ros-melodic-rqt-image-view ros-melodic-gmapping ros-melodic-navigation ros-melodic-interactive-markers
```
3. Install packages for Turtlebot3 (it contains node for simulation).
```
cd ~/catkin_ws/src/
git clone https://github.com/ROBOTIS-GIT/turtlebot3_msgs.git
git clone https://github.com/ROBOTIS-GIT/turtlebot3.git
git clone https://github.com/ROBOTIS-GIT/turtlebot3_simulations.git
cd ~/catkin_ws && catkin_make
```
4. In the next steps you should configure your network.
```
sudo nano ~/.bashrc
// EDIT FIELDS: Replace with your ip adress. Please not that you should not use http://localhost:11311 because it won't work.
// Get your ip with: hostname -I
// EXAMPLE: export ROS_MASTER_URI=http://192.221.1.11:11311
// EXAMPLE: export ROS_HOSTNAME=192.221.1.11
// REPLACE: 192.221.1.11 with your ip.
```
5. Install camera package.
```
cd ~/catkin_ws/src/
git clone https://github.com/OTL/cv_camera.git
cd ~/catkin_ws && catkin_make

// EXAMPLE of use: rosparam set cv_camera/device_id 001
// EXAMPLE of use: rosrun cv_camera cv_camera_node
```
6. Export ROS parameters; simulated robot model. I use waffle_pi. Add appropriete line to your bashrc.
```
export TURTLEBOT3_MODEL=waffle_pi
```

## Running ROS with application.
Refer [ROBOTIS e-Manual for more information.](http://emanual.robotis.com/docs/en/platform/turtlebot3/overview/#overview)

### Launch ROS
Read instruction how to use launch nodes and fake node in [simulation chapter](http://emanual.robotis.com/docs/en/platform/turtlebot3/simulation/#simulation).
```
roscore
roslaunch turtlebot3_fake turtlebot3_fake.launch
roslaunch turtlebot3_gazebo turtlebot3_house.launch
roslaunch turtlebot3_slam turtlebot3_slam.launch slam_methods:=gmapping
roslaunch turtlebot3_navigation turtlebot3_navigation.launch 
//NOTE: This is example, adjust paths to launch files.
roslaunch '/home/rongix/catkin_ws/src/turtlebot3/turtlebot3_navigation/launch/move_base.launch'
```
### Configure ROS params in mobile app settings

### Voice commands
To use voice commands you have to configure your own dialogflow agent
