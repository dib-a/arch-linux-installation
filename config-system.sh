#!/bin/bash

#vim /etc/locale.gen
cp src/locale.gen /etc/locale.gen
locale-gen

ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
hwclock --systohc --utc

echo pc > /etc/hostname
passwd
#vim /etc/sudoers
cp src/sudoers /etc/sudoers

systemctl enable dhcpcd

#vim /etc/mkinitcpio.conf
cp src/mkinitcpio.conf /etc/mkinitcpio.conf
mkinitcpio -P

grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=arch --recheck
#vim /etc/default/grub
cp src/grub /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg

exit
