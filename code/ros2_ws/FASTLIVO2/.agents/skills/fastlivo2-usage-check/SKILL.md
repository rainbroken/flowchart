---
name: fastlivo2-usage-check
description: Review, configure, run, and troubleshoot FAST-LIVO2 on ROS 2 with Livox MID360, IMU, and USB camera. Use for FAST-LIVO2 compilation failures, missing sensor topics, no point-cloud output, hardware synchronization checks, timestamp errors, TF errors, unstable mapping, camera configuration, Livox driver problems, and Raspberry Pi resource issues. Do not use for generic ROS 2 questions unrelated to FAST-LIVO2.
---

# FAST-LIVO2 使用与诊断规范

## 目标

对 FAST-LIVO2 工程进行配置审查、编译检查、运行检查和故障诊断。

主要关注：

- ROS 2 环境是否正确
- FAST-LIVO2 工作空间是否完整
- Livox MID360、IMU 和相机驱动是否正常
- 传感器话题名称是否与配置文件一致
- LiDAR、IMU、Camera 时间戳是否有效
- 硬件同步是否真正生效
- 相机内参和雷达—相机外参是否正确
- TF 树是否完整
- FAST-LIVO2 输出话题是否正常
- 建图结果是否稳定
- 树莓派或嵌入式主机资源是否足够

## 默认项目背景

项目通常使用：

- Ubuntu 22.04
- ROS 2 Humble
- Livox MID360
- USB 全局快门相机
- Livox ROS Driver 2
- FAST-LIVO2
- Intel NUC 或 Raspberry Pi 5B
- STM32 硬件同步板
- colcon 构建系统

以上内容只是默认背景。

执行任务前必须检查实际环境，不得直接假设 ROS 版本、工作空间路径、设备号、话题名称或配置文件名称。

## 基本原则

1. 先诊断，再修改。
2. 修改任何 YAML、launch、CMakeLists.txt 或 package.xml 前，先读取现有内容。
3. 修改配置文件前创建备份。
4. 不得凭空假设话题名称。
5. 不得把其他 FAST-LIVO2 分支的配置直接套用到当前仓库。
6. 不得混用 ROS 1 和 ROS 2 命令。
7. 不得在未确认情况下执行删除 build、install、log 的命令。
8. 不得随意执行 sudo、apt remove、rm -rf 或修改系统网络配置。
9. 必须区分：
   - 传感器硬件时间戳
   - ROS 消息 header.stamp
   - 驱动接收时间
   - 系统当前时间
10. 不要仅根据“话题存在”判断系统正常。
11. 不要仅根据 RViz 中出现点云判断同步正确。
12. 不要把 1 Hz 同步脉冲直接解释为雷达只有 1 Hz 采集率；先核对雷达同步模式和驱动配置。
13. 所有结论必须区分：
   - 已验证事实
   - 高概率原因
   - 尚未验证的可能原因

## 标准诊断流程

### 第一步：确认环境

先执行只读检查：

```bash
pwd
ls
find src -maxdepth 2 -name package.xml -print
echo "$ROS_DISTRO"
printenv | grep -E "ROS|AMENT|COLCON"
uname -a
lsb_release -a 2>/dev/null || cat /etc/os-release