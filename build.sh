#!/bin/bash
# This script runs inside the emulated Raspberry Pi!

echo "Starting Drona OS Customization..."

# 1. Update the system
apt-get update

# 2. Change the hostname to 'drona'
echo "drona" > /etc/hostname
sed -i 's/raspberrypi/drona/g' /etc/hosts

# 3. Download the Drona Code from GitHub
cd /home/pi
git clone https://github.com/ahmedvictor507/Drona.git
mv Drona /home/pi/catkin_ws/src/

# 4. Set up the Drona background service
cat << 'EOF' > /etc/systemd/system/drona.service
[Unit]
Description=Drona ROS package
Requires=roscore.service
After=roscore.service network.target

[Service]
User=pi
ExecStart=/opt/ros/noetic/bin/roslaunch drona drona.launch --screen
Restart=on-failure
RestartSec=3

[Install]
WantedBy=multi-user.target
EOF

systemctl enable drona.service

# 5. Fix permissions so the 'pi' user owns the new code
chown -R pi:pi /home/pi/catkin_ws

echo "Drona OS Customization Complete!"
