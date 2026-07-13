ros2 bag record \
  /camera1/image_raw \
  /livox/imu \
  /livox/lidar \
  -o ./rosbag/$(date +%Y%m%d_%H%M%S) \
  