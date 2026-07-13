
本文档的所有命令，都是在
$HOME/ros2_driver下操作，该功能包存放所有驱动
文件根目录为
$HOME/ros2_driver
	├── lib			#存放lib驱动
	└── utilities		#存放ros2驱动

```shell
mkdir -p $HOME/ros2_driver/lib && mkdir -p $HOME/ros2_driver/utilities
```


一、realsense编译步骤
1.预备操作
#更新apt并安装插件
```shell
sudo apt-get update && sudo apt-get upgrade && sudo apt-get dist-upgrade
sudo apt-get install git libssl-dev libusb-1.0-0-dev libudev-dev pkg-config libgtk-3-dev cmake
```
#对于不同ubuntu版本还需要安装不同的包
    #Ubuntu 14 or when running Ubuntu 16.04 live-disk:
    ./scripts/install_glfw3.sh
    #Ubuntu 16:
    sudo apt-get install libglfw3-dev
    #Ubuntu 18/20/22:
    sudo apt-get install libglfw3-dev libgl1-mesa-dev libglu1-mesa-dev at

2.拔下realsense设备然后进入realsenseSDK的仓库并运行
```shell
cd $HOME/ros2_driver/lib
```

#下载源码,默认安装最新版本
```shell
git clone https://github.com/IntelRealSense/librealsense.git
```

#运行realsense的脚本
```shell
./scripts/setup_udev_rules.sh该命令用于获得权限
./scripts/setup_udev_rules.sh --uninstall可以卸载上面命令
```
 
#安装应用补丁内核模块，不同版本安装不同补丁
 
    # Ubuntu 20/22 (focal/jammy) with LTS kernel 5.13, 5.15 
    ./scripts/patch-realsense-ubuntu-lts-hwe.sh
 
    #Ubuntu 14/16/18/20 with LTS kernel (< 5.13)
    ./scripts/patch-realsense-ubuntu-lts.sh
 
    #Ubuntu with Kernel 4.16
    ./scripts/patch-ubuntu-kernel-4.16.sh

3.准备编译安装
#在realsense仓库目录下建立build文件夹
```shell
cd cd $HOME/ros2_driver/lib/librealsense
mkdir build && cd build
cmake ../ 
# cmake ../ -DBUILD_EXAMPLES=true 
# cmake ../ -DBUILD_EXAMPLES=true -DBUILD_GRAPHICAL_EXAMPLES=false #For systems without OpenGL or X11 build only textual examples
```
 
#如果编译有问题，更改一下代理，端口根据实际情况更改，然后再运行上面的编译
```
export http_proxy=http://127.0.0.1:7890
export https_proxy=http://127.0.0.1:7890
git config --global http.proxy http://127.0.0.1:7890
git config --global https.proxy https://127.0.0.1:7890
```
#make，但是不清楚为什么先uninstall一遍
```shell
sudo make uninstall && make clean && make && sudo make install
```
 
------------------------------执行到这里，基本就结束了，以下的可以先不用管--------------------------------
```shell
# 依次运行
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-key F6E65AC044F831AC80A06380C8B3A55A6F3EFCDE || sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key F6E65AC044F831AC80A06380C8B3A55A6F3EFCDE
#如果出现key添加失败就在/etc/apt/sources.list 和/etc/apt/sources.list.d里删除对应地址
sudo add-apt-repository "deb https://librealsense.intel.com/Debian/apt-repo $(lsb_release -cs) main" -u
sudo apt-get install librealsense2-dkms
sudo apt-get install librealsense2-utils
```
--------------------------------------------------------------------------------------------------------


4.建立一个ROS2工作空间：
```shell
mkdir -p $HOME/ros2_driver/utilities/realsense_driver/src
cd $HOME/ros2_driver/utilities/realsense_driver/src/
```

#Clone the latest ROS2 Intel® RealSense™ wrapper from here into '$HOME/ros2_driver/realsense_driver/src/'
```shell
git clone https://github.com/IntelRealSense/realsense-ros.git 
cd $HOME/ros2_driver/realsense_driver
```

#安装依赖Install dependencies
```shell
sudo apt-get install python3-rosdep -y
sudo rosdep init # "sudo rosdep init --include-eol-distros" for Eloquent and earlier
rosdep update # "sudo rosdep update --include-eol-distros" for Eloquent and earlier
rosdep install -i --from-path src --rosdistro $ROS_DISTRO --skip-keys=librealsense2 -y
```

#如果上一步失败，采用鱼香ros的初始化rosdepc
```shell
wget http://fishros.com/install -O fishros && . fishros 
sudo rosdepc init
rosdepc update
rosdepc install -i --from-path src --rosdistro $ROS_DISTRO --skip-keys=librealsense2 -y 
```
 
5.编译+初始化
```shell
colcon build --symlink-install --cmake-args -DCMAKE_BUILD_TYPE=Release
echo "source $HOME/ros2_driver/utilities/realsense_driver/install/setup.bash" >> ~/.bashrc
#检查是否有问题
tail -n 3 ~/.bashrc
```


二、mid360驱动安装

1.livox_sdk2安装
```shell
cd $HOME/ros2_driver/lib
git clone https://github.com/Livox-SDK/Livox-SDK2.git
cd ./Livox-SDK2/
mkdir build
cd build
cmake .. && make -j
sudo make install
```

2.livox_driver2安装
```shell
mkdir -p $HOME/ros2_driver/utilities/livox_ws/src
cd $HOME/ros2_driver/utilities/livox_ws/src
git clone https://github.com/Livox-SDK/livox_ros_driver2.git 
cd ..
colcon build --cmake-args -DROS_EDITION=ROS2 -DCMAKE_BUILD_TYPE=Release -DHUMBLE_ROS=humble
echo "source $HOME/ros2_driver/utilities/livox_ws/install/setup.bash" >> ~/.bashrc
#检查是否有问题
tail -n 3 ~/.bashrc
```





