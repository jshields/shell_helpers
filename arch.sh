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
# WARN: this disk name will vary
fdisk /dev/sdb

# Create EFI partition
# new
n
# partition number 1
# (consider deleting old partition if this starts at 2 and doesn't allow 1 - WARN: deleting partition results in data loss)
# <Enter>
# Enter again - default first sector 2048 (slight wasted space but may be needed by GRUB? Need to revisit this, but starting at 2048 is fine)
#  2048 may cause things to line up better with the partitions, or is it just legacy backwards compatibility with MBR/DOS?
# <Enter>
# Desired size. 1000MB
+1G
# change type
t
# EFI partition number (defaults 1)
# 1
# Select 1 for EFI System type
1

# (No Swap partition. Plan to have enough RAM / use swap file on disk)

# Create root Linux file system partition
# new
n
# default partition number 2
# <Enter>
# (default first sector)
# <Enter>
# (use remaining space)
# <Enter>
# It will default to Linux Filesystem,
# but change it to Linux root for the appropriate architecture, i.e. Linux root (x86-64), to be slightly more correct
23
# write
w

# format the partitions with the appropriate file systems
# identify partitions to format
fdisk -l
lsblk
parted -l

# (replace root_partition and efi_system_partition here with actual identifiers)
mkfs.ext4 /dev/root_partition
# mkfs.ext4 /dev/sdb2
# mkswap /dev/swap_partition - no swap partition for this setup
mkfs.fat -F 32 /dev/efi_system_partition
# mkfs.fat -F 32 /dev/sdb1

mount /dev/sdb2 /mnt
mount --mkdir /dev/sdb1 /mnt/boot

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
# If too unstable, use linux-lts kernel package. But, Linux kernel 6.14 includes gaming performance improvements and device drivers.

# Step 3
genfstab -U /mnt >> /mnt/etc/fstab

# list timezones outside chroot to double check which name to use below - e.g. America/Chicago
timedatectl list-timezones

# Bootloader can be installed from outside chroot or not, just be sure efi-directory is right
# pacstrap -K efibootmgr grub
# grub-install --target=x86_64-efi --efi-directory=/mnt/boot --bootloader-id=ARCHGRUB --removable
# grub-mkconfig -o /mnt/boot/grub/grub.cfg

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

# setup boot loader in the ESP (EFI System Partition).
# doinng this after chroot, so the commands are run inside the new system.
# These steps write the boot option to the NVRAM of the motherboard normally,
# but not with --removable, needed for MSI motherboard which otherwise doesn't see grub.
pacman -S efibootmgr grub
# --removable needed for MSI motherboard!
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=ARCHGRUB --removable
grub-mkconfig -o /boot/grub/grub.cfg


# Personal note: old "ubuntu" boot entry for Linux Mint on 1TB SSD should be removed at some point using efibootmgr, or totally reformat Windows drive
# https://wiki.archlinux.org/title/Unified_Extensible_Firmware_Interface#efibootmgr

# exit chroot jail
exit
# manually unmount in case there are busy partitions
umount -R /mnt

# Side note, accidentally started using systemd-networkd then removed:
# rm /etc/systemd/network/20-wired.network
# systemctl disable systemd-networkd
# systemctl stop systemd-networkd
# systemctl stop systemd-networkd.socket

ip link
ip address show
networkctl list
# manually bring up ethernet interface if DOWN / off
ip link set enp4s0 up

# install more packages
# general
pacman -S man-db man-pages texinfo which less wget htop nano

# file system packages
pacman -S fsck e2fsprogs

# kernel audio drivers should be fine.
# TODO: check which devices are supported.
# newest kernel includes drivers for some SteelSeries headsets.
# https://github.com/archlinux/archinstall/blob/87fb96d249f5660f5dc2095d33dc078028705fdf/archinstall/lib/models/audio_configuration.py
# https://github.com/archlinux/archinstall/blob/master/archinstall/default_profiles/applications/pipewire.py#L16-L25
# May want pipewire ?

# Intel
pacman -S intel-ucode

# verify microcode was installed
# https://wiki.archlinux.org/title/Microcode#Microcode_initramfs_packed_together_with_the_main_initramfs_in_one_file
# You can verify the initramfs includes the microcode update files with lsinitcpio. E.g.:
# lsinitcpio --early /boot/initramfs-linux.img | grep microcode
# kernel/x86/microcode/
# /kernel/x86/microcode/GenuineIntel.bin
# then verify early load after next boot:
# journalctl -k --grep='microcode:'

# AMD GPU
# amdgpu driver comes with Linux kernel, and should load automatically on boot.
# vulkan-radeon is part of mesa, installing separately is not necessary
# https://github.com/archlinux/archinstall/blob/6c7260fa336909c7a9775dcf2f3cb78027e7af3c/archinstall/lib/hardware.py#L102-L109
pacman -S mesa
# If having trouble with Wayland, install packages needed for xorg: xf86-video-amdgpu, xf86-video-ati ?
# how to verify amdgpu module is loaded?

# nano /etc/default/grub
# change colors / theme: https://www.gnu.org/software/grub/manual/grub/html_node/color_005fnormal.html
# then regenerate with grub-mkconfig as normal

# setup your own user (it's a bad practice to login as root all the time)
useradd --groups adm,sys,log,rfkill,uucp,wheel,http,games --create-home josh
passwd josh
# <set password>

pacman -S sudo
# https://wiki.archlinux.org/title/Sudo#Configuration
EDITOR=nano visudo
nano /etc/sudoers
# %wheel    ALL=(ALL) ALL

# login as personal user rather than root - consider disabling root once your user can use sudo

# Plasma desktop (with KWin Wayland compositor).
# Packages in this group / dependency tree include i.e. network manager for managing networks via desktop as well.
# https://github.com/archlinux/archinstall/blob/master/archinstall/default_profiles/desktops/plasma.py
# https://wiki.archlinux.org/title/KDE#Installation
# see kde-applications-meta for other basic desktop programs
# plasma-meta depends on networkmanager - that will be used, not systemd-networkd or another network/dhcp manager
pacman -Syu plasma-meta kde-utilities-meta kde-system-meta flatpak
# 2 providers available for qt6-multimedia-backend: 1 qt6-multimedia-ffmpeg / 2 qt6-multimedia-gstreamer = 1
# provider for jack: 1 jack2 OR 2 pipewire-jack = 2
# provider for ttf-font: 1 gnu-free-fonts OR 2 noto-fonts = 2
# provider for phonon-qt6-backend: 1 phonon-qt6-mpv OR 2 phonon-qt6-vlc = 2
# provider for tessdata: English https://archlinux.org/packages/extra/any/tesseract-data-eng/
# provider for cron: cronie

# Installing and running Discord as a flatpak may improve performance.
# https://wiki.archlinux.org/title/Discord
# pacman install flatpak
# flatpak install discord

reboot

# enable desktop and network manager
# https://wiki.archlinux.org/title/SDDM
# https://wiki.archlinux.org/title/NetworkManager
sudo systemctl enable NetworkManager
sudo systemctl start NetworkManager

# See that Ethernet is connected
nmcli device

# WARN: once you do this, you will lose the terminal because the desktop greeter / login page will get displayed
sudo systemctl enable sddm
sudo systemctl start sddm


# gaming applications
pacman -Syu gamescope lutris discord

# enable multilib and install steam
pacman -Syu steam

# Select "Plasma (wayland)" from login manager if it is not selected.
# Wayland is needed for gamescope.

# If the system frequently breaks and requires reinstall, consider btrfs filesystem which supports easier snapshots,
# or install with LVM for managing ext4 filesystem.


# https://community.kde.org/Distributions/Packaging_Recommendations#Systemd_configuration
# https://community.kde.org/Distributions/Packaging_Recommendations#Kernel_configuration
# https://community.kde.org/Distributions/Packaging_Recommendations#KWin_package_configuration

# pacman -Syu zsh git
# Before changing shells, check that zsh is in `/etc/shells` / `chsh -l`
# chsh /usr/bin/zsh


# if troubleshooting is needed, use install media again and remount, re-chroot
# this will give a recovery terminal
mount /dev/sdb2 /mnt
mount /dev/sdb1 /mnt/boot
arch-chroot /mnt

# (For real security, encrypt your drive, otherwise anyone with a thumb drive can login as root)


# reboot / shutdown as needed
# Will need to reboot after exiting chroot etc in order to access actual installed system
reboot
shutdown --poweroff now

# ----------------------
# Nvidia drivers caveats - no longer needed with AMD card

# pacman install nvidia-dkms dkms
# Enable the kernel options for the Nvidia proprietary drivers.
# Without these set, Wayland login to Plasma desktop will result in a black screen.
# nano /etc/default/grub
# nvidia_drm.modeset=1
# nvidia-drm.fbdev=1
# GRUB_CMDLINE_LINUX_DEFAULT="nvidia-drm.modeset=1 nvidia-drm.fbdev=1"
# grub config must be regenerated after making changes
# grub-mkconfig -o /boot/grub/grub.cfg
# Once things are stable, adding `quiet splash` here will give a splash screen during boot instead of log messages.
# Verify nvidia kernel parameters are set - should return "Y".
# Reboot will be needed since grub needs to pass in the parameter on boot.
# cat /sys/module/nvidia_drm/parameters/modeset
# cat /sys/module/nvidia_drm/parameters/fbdev

# cat /proc/driver/nvidia/params | sort
# NVreg_PreserveVideoMemoryAllocations=1

# Add this line to KWin config
# https://blog.davidedmundson.co.uk/blog/running-kwin-wayland-on-nvidia/
# nano /etc/profile.d/kwin.sh
# export KWIN_DRM_USE_EGL_STREAMS=1
