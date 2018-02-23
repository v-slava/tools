#!/bin/bash

#see for reference:
# https://www.raspberrypi.org/magpi/pi-zero-w-smart-usb-flash-drive/
# https://raspberrypi.stackexchange.com/questions/63914/unable-to-configure-a-raspberry-pi-zero-as-a-usb-mass-storage-device-using-g-mas
sudo apt-get update
sudo apt-get upgrade

echo "dtoverlay=dwc2" | sudo tee -a /boot/config.txt

#TODO
#need to /etc/modules
#Append the line below, just after the i2c-dev line:
#dwc2

sudo dd bs=1M if=/dev/zero of=/piusb.bin count=4096
sudo mkdosfs /piusb.bin -F 32 -I
sudo mkdir /mnt/usb_share

echo "/piusb.bin /mnt/usb_share vfat users,umask=000 0 2" | sudo tee -a /etc/fstab
sudo mount -a

sudo modprobe g_mass_storage file=/piusb.bin stall=0 ro=1