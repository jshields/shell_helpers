# https://wiki.archlinux.org/title/Installation_guide

# Before reformatting, just unplug SSD and HDD that won't be used for this.

# Partitioning scheme:
# 1 GB EFI partition type, mounted as /boot, FAT32 file system (disk does not already have an EFI partition)
# rest of the SSD partitioned as normal Linux filesystem, mounted at root /, ext4 file system

# Probably don't need swap partition with 32GB RAM, and swap file would be fine if needed.
# https://wiki.archlinux.org/title/Swap#Swap_file
# zram memory compression can also be used as swap space
# https://wiki.archlinux.org/title/Zram#Usage_as_swap

# Step 2.1
# check /etc/pacman.d/mirrorlist

# Step 2.2
# install base packages in live session from boot media, using pacstrap for new system installation:
pacstrap -K /mnt base linux linux-firmware

echo "josh-pc" >> /etc/hostname

# Step 3
genfstab -U /mnt >> /mnt/etc/fstab

# change root into the new system
arch-chroot /mnt

# set root password
# In post installation steps, root user will be disabled after a user with sudo is created
passwd

# setup boot loader in the ESP (EFI System Partition)
# be sure to do this after chroot, so the commands are run inside the new system
# this step writes the boot option to the NVRAM of the motherboard and creates /boot/efi/grub
pacman install efibootmgr grub
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

# NOTE: old "ubuntu" boot entry for Linux Mint should be removed at some point using efibootmgr
# https://wiki.archlinux.org/title/Unified_Extensible_Firmware_Interface#efibootmgr

# exit chroot jail
exit
# manually unmount in case there are busy partitions
umount -R /mnt

# reboot and login as root
reboot




# set time and default localization per wiki

# install more packages
# general
pacman install man-db which less wget htop openssh nano

# file system packages
pacman install fsck e2fsprogs

# Audio:
# https://github.com/archlinux/archinstall/blob/87fb96d249f5660f5dc2095d33dc078028705fdf/archinstall/lib/models/audio_configuration.py
# TODO
# https://github.com/archlinux/archinstall/blob/master/archinstall/default_profiles/applications/pipewire.py#L16-L25
# sof-firmware

# Intel and Nvidia
pacman install intel-ucode nvidia-dkms dkms

# desktop
# Xorg as a backup in case Wayland session has issues
pacman install  xorg-server xdg-utils plasma-meta plasma-workspace konsole kate dolphin ark

# gaming
pacman install steam gamescope lutris
