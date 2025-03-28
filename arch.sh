# https://wiki.archlinux.org/title/Installation_guide
# this is intended as a cheat sheet for one specific install / setup of Arch Linux
# should not be run as a script

cat /sys/firmware/efi/fw_platform_size
# should return 64

# ensure Internet connection (needed for installing packages during initial setup)
ip link
ping archlinux.org

timedatectl

# Before booting from USB, just unplug SSD and HDD that won't be used for this install.

# Partitioning scheme:
# 1 GB EFI partition type, mounted as /boot, FAT32 file system (disk does not already have an EFI partition)
# rest of the SSD partitioned as normal Linux filesystem, mounted at root /, ext4 file system

# partition the SSD
# Identify the disk (replace /dev/sda with your disk)
fdisk -l
lsblk

# Start fdisk
# fdisk /dev/the_disk_to_be_partitioned
# 2TB SSD
fdisk /dev/sda

# Create EFI partition
# new
n
# Enter to leave as default partition number 1
# <Enter>
# Enter again - default first sector
# <Enter>
# Desired size. 1000MB
+1000M
# change type
t
# EFI partition number (defaults 1)
1
# Select 1 for EFI System type
1

# Create root Linux file system partition
# new
n
# default partition number 1
# <Enter>
# (default first sector)
# <Enter>
# (use remaining space)
# <Enter>
# write
w

# format the partitions with the appropriate file systems
# identify partitions to format
fdisk -l
lsblk

# (replace root_partition and efi_system_partition here with actual identifiers)
mkfs.ext4 /dev/root_partition
mkfs.fat -F 32 /dev/efi_system_partition

mount /dev/root_partition /mnt
mount --mkdir /dev/efi_system_partition /mnt/boot

# verify the SSD looks right
fdisk -l
lsblk
parted -l

# Probably don't need swap partition with 32GB RAM, and swap file would be fine if needed.
# https://wiki.archlinux.org/title/Swap#Swap_file
# zram memory compression can also be used as swap space
# https://wiki.archlinux.org/title/Zram#Usage_as_swap

# Step 2.1
# check mirrors
cat /etc/pacman.d/mirrorlist

# Step 2.2
# install base packages in live session from boot media, using pacstrap for new system installation:
pacstrap -K /mnt base linux linux-firmware
# If too unstable, use linux-lts kernel package. Linux kernel 6.14 includes gaming performance improvements and device drivers.

# Step 3
genfstab -U /mnt >> /mnt/etc/fstab

# list timezones outside chroot to make sure the name is right
timedatectl list-timezones

# change root into the new system
arch-chroot /mnt

# set time
# set the timezone that seems right
# can't use timedatectl from chroot, but the command would normally be:
# timedatectl set-timezone America/Chicago
ln -sf /usr/share/zoneinfo/America/Chicago /etc/localtime
hwclock --systohc

# Edit /etc/locale.gen and uncomment en_US.UTF-8 UTF-8
# Then:
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf

# network config
echo "josh-pc" >> /etc/hostname

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

# install more packages
# general
pacman install man-db which less wget htop openssh nano

# file system packages
pacman install fsck e2fsprogs

# TODO
# Audio setup:
# https://github.com/archlinux/archinstall/blob/87fb96d249f5660f5dc2095d33dc078028705fdf/archinstall/lib/models/audio_configuration.py
# https://github.com/archlinux/archinstall/blob/master/archinstall/default_profiles/applications/pipewire.py#L16-L25
# sof-firmware

# Intel and Nvidia
pacman install intel-ucode nvidia-dkms dkms

# Plasma desktop ( withKWin Wayland compositor).
# Packages in this group / dependency tree include i.e. network manager for managing networks via desktop as well.
# https://github.com/archlinux/archinstall/blob/master/archinstall/default_profiles/desktops/plasma.py
# https://wiki.archlinux.org/title/KDE#Installation
# see kde-applications-meta for other basic desktop programs
pacman install plasma-meta kde-utilities-meta kde-system-meta

# gaming applications
pacman install steam gamescope lutris discord

# Installing and running Discord as a flatpak may improve performance.
# https://wiki.archlinux.org/title/Discord
# pacman install flatpak
# flatpak install discord

# Enable the kernel options for the Nvidia proprietary drivers.
# Without these set, Wayland login to Plasma desktop will result in a black screen.
nano /etc/default/grub
# nvidia_drm.modeset=1
# nvidia-drm.fbdev=1
GRUB_CMDLINE_LINUX_DEFAULT="nvidia-drm.modeset=1 nvidia-drm.fbdev=1"
# grub config must be regenerated after making changes
grub-mkconfig -o /boot/grub/grub.cfg
# Once things are stable, adding `quiet splash` here will give a splash screen during boot instead of log messages.
# Verify nvidia kernel parameters are set - should return "Y".
# Reboot will be needed since grub needs to pass in the parameter on boot.
cat /sys/module/nvidia_drm/parameters/modeset
cat /sys/module/nvidia_drm/parameters/fbdev

cat /proc/driver/nvidia/params | sort
# NVreg_PreserveVideoMemoryAllocations=1

# Add this line to KWin config
# https://blog.davidedmundson.co.uk/blog/running-kwin-wayland-on-nvidia/
nano /etc/profile.d/kwin.sh
export KWIN_DRM_USE_EGL_STREAMS=1

# Select "Plasma (wayland)" from your login manager.
# Wayland is needed for gamescope.
# Trying to mirror SteamOS' setup as much as possible while maintaining a standalone OS/desktop.

# If the system frequently breaks and requires reinstall, consider btrfs filesystem which supports easier snapshots,
# or install with LVM for managing ext4 filesystem.

