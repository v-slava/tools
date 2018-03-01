#!/bin/bash

#see for reference:
# https://www.raspberrypi.org/magpi/pi-zero-w-smart-usb-flash-drive/
# https://raspberrypi.stackexchange.com/questions/63914/unable-to-configure-a-raspberry-pi-zero-as-a-usb-mass-storage-device-using-g-mas
sudo apt-get update
sudo apt-get upgrade

# Configure WI-FI:
if [ -z "$WIFI_SSID" ] || [ -z "$WIFI_PASSWORD" ]; then
    echo -e "Error: please set both environment variables:\n\
\$WIFI_SSID and \$WIFI_PASSWORD" 1>&2
    exit 1
fi

cat << EOF | sudo tee -a /etc/wpa_supplicant/wpa_supplicant.conf
network={
  ssid="$WIFI_SSID"
  psk="$WIFI_PASSWORD"
  proto=RSN
  key_mgmt=WPA-PSK
  pairwise=CCMP
  auth_alg=OPEN
}
EOF

cat << EOF | sudo tee /etc/network/interfaces.d/wlan0
auto wlan0
allow-hotplug wlan0
iface wlan0 inet dhcp
    wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf
EOF

# Enable SSH-server (after reboot):
touch /boot/ssh

echo "dtoverlay=dwc2" | sudo tee -a /boot/config.txt

cat << EOF | sudo tee -a /etc/modules
dwc2
g_mass_storage
EOF

echo "options g_mass_storage file=/piusb.bin stall=0 removable=1" | sudo tee /etc/modprobe.d/usb_storage.conf

sudo dd bs=1M if=/dev/zero of=/piusb.bin count=4096
echo -e "o\nn\np\n\n\n\nt\nc\nw\n" | sudo fdisk /piusb.bin
sudo apt-get install kpartx
# losetup -l # print info about loop devices present
sudo kpartx -a /piusb.bin
sudo mkfs -t vfat -F 32 -n INSTALL /dev/mapper/loop0p1

# Add some contents to partition on USB stick:
sudo mkdir /mnt/usb_share
sudo mount /dev/mapper/loop0p1 /mnt/usb_share/
echo -e "Now spawn another shell, copy contents to USB stick\n\
(in /mnt/usb_share/) and press enter here when done..."
read
sudo umount /mnt/usb_share

sudo kpartx -d /piusb.bin

# The following commands are not needed anymore (everything should work after reboot):
sudo mount -a

sudo modprobe g_mass_storage file=/piusb.bin stall=0 removable=1
