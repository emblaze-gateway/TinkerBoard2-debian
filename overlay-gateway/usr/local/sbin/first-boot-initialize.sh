#!/bin/bash

sleep 40s

systemctl disable --now hostapd
systemctl disable --now dhcpcd

systemctl disable bluetooth.service
systemctl enable bluetooth-mesh.service

systemctl enable emblaze-usb.service
systemctl enable rabbitmq.service
systemctl enable emblaze-gateway.service

nmcli radio wifi off

sleep 40s

echo "emblaze:emblaze" | chpasswd

sleep 1s

sync

reboot
