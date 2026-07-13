colcon build --packages-select usb_cam
source install/setup.bash 
ros2 launch usb_cam camera.launch.py
