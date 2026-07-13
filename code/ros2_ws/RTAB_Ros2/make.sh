1.apt安装(不推荐)
sudo apt install ros-humble-rtabmap-ros
#rviz插件（可选）
sudo apt install ros-humble-rtabmap-rvizsudo apt install ros-humble-rtabmap-rviz

2.源码安装(推荐)
mkdir -p rtab_ws/src
cd rtab_ws/src
#下载rtabmap源码
git clone https://github.com/introlab/rtabmap.git -b master
git clone https://github.com/introlab/rtabmap_ros.git -b humble-devel

3.安装依赖
rosdep install -i --from-path src --rosdistro humble -y

4.编译
cd ..
//编译成功
colcon build   --symlink-install   --cmake-args   -DCMAKE_BUILD_TYPE=Release   -DWITH_GTSAM=OFF
# colcon build --symlink-install --parallel-workers 1 --cmake-args -DCMAKE_BUILD_TYPE=Release -Wno-dev
# colcon build --symlink-install --cmake-args "-DCMAKE_BUILD_TYPE=Release"

参考文献
https://github.com/lijinghai/RabbitRobot-D435-L1lidar-RTABMap-ROS2


