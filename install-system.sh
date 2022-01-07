#!/bin/bash

pacman -Syyu
systemctl enable --now systemd-timesyncd

cfdisk /dev/sda
mkfs.vfat -F 32 -n EFI /dev/sda1
mkfs.ext4 -L BOOT /dev/sda2
mkswap -L SWAP /dev/sda4
cryptsetup -v -y --cipher aes-xts-plain64 --key-size 256 --hash sha256 --iter-time 2000 --use-urandom --verify-passphrase luksFormat /dev/sda3
cryptsetup open /dev/sda3 SYSTEM
mkfs.ext4 -L SYSTEM /dev/mapper/SYSTEM

mount -L SYSTEM /mnt
mkdir /mnt/boot
mount -L BOOT /mnt/boot
mkdir /mnt/boot/efi
mount -L EFI /mnt/boot/efi
swapon -L SWAP

pacstrap /mnt base base-devel linux linux-firmware dhcpcd grub mkinitcpio efibootmgr git vim sudo

# for wifi uncomment the command below
# pacstrap /mnt base base-devel linu linux-firmware dhcpcd grub mkinitcpio efibootmgr git vim sudo wpa_supplicant dialog

arch-chroot /mnt
