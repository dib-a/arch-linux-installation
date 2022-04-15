# Arch Linux Installation (minimal and crypted)

You have to ```clone the repository``` and run ```bash ```install-system.sh or do it yourself as explained bellow:

1. Format the memory:
```bash
cfdisk /dev/sdX
```
You have to change the X into the number of the memory (you can look it up by using ```lsblk```)
> For this example I use a 128 GB memory. You can decide how you want make the partition

In this example it will be:

|Name|Size|Partitionname|
|-------|----|------------------|
|/dev/sda1|300 MB|EFI| 
|/dev/sda2|300 MB|BOOT|
|/dev/sda3|all left|SYSTEM|
|/dev/sda4|8 GB| SWAP

Make the file system and crypt the ```SYSTEM```:
```bash
mkfs.vfat -F 32 -n EFI /dev/sda1
mkfs.ext4 -L BOOT /dev/sda2
mkswap -L SWAP /dev/sda4

cryptsetup -v -y --cipher aes-xts-plain64 --key-size 256 --hash sha256 --iter-time 2000 --use-urandom --verify-passphrase luksFormat /dev/sda3
cryptsetup open /dev/sda3 SYSTEM

mkfs.ext4 -L SYSTEM /dev/mapper/SYSTEM
```

Mount the partitions and turn the swap on:
```bash
mount -L SYSTEM /mnt
mkdir /mnt/boot
mount -L BOOT /mnt/boot
mkdir /mnt/boot/efi
mount -L EFI /mnt/boot/efi

swapon -L SWAP
```

Now you can install the main system, if not updated you may have to change the ```linux-kernel```:
```bash
pacstrap /mnt base base-devel linux linux-firmware dhcpcd grub mkinitcpio efibootmgr git vim sudo
```
If you need wifi-connection add wpa_supplicant and dialog

Change into the new System, 
```bash
arch-chroot /mnt
```

You have to ```clone the repository``` another time and run ```bash ```config-system.sh or do it yourself as explained bellow:

Setup the language:

```bash
vim /etc/locale.gen
locale-gen
```

Setup the time:
```bash
ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
hwclock --systohc --utc
```

Name the device and set the root password:
```bash
echo enterTheName > /etc/hostname
passwd
```

Add the encrypt hook:
```bash
vim /etc/mkinitcpio.conf
mkinitcpio -P
```

Setup the grub:
```bash
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=arch --recheck
vim /etc/default/gtrub
grub-mkconfig -o /boot/grub/grub.cfg
```

Exit the chroot
```bash
exit
```

Umount all devices:
```bash
umount -R /mnt
```

Close the crypted device:
```bash
cryptsetup close SYSTEM
```
