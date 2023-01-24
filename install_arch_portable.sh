#!/bin/bash
# partition
	# partition logique /boot et /boot/efi
	# partition lvm home var et /
	

# A LIRE OBLIGATOIREMENT AVANT INSTALLATION ET A ADAPTER SUIVANT LES SITUATIONS PRESENTES

# Ce petit script installe les essentiels d'archlinux. Il est à utiliser dans le chroot, après le partitionnement, ainsi que l'installation des paquets de base
# liste des paquets de base: installation via pacstrap /mnt base base-devel vim amd/intel-ucode linux-lts linux-firmware grub efibootmgr

ln -sf /usr/share/zoneinfo/Indian/Antananarivo /etc/localtime
hwclock --systohc

echo "LANG=fr_FR.UTF-8" >> /etc/locale.conf
echo "LC_COLLATE=C" >> /etc/locale.conf
echo "KEYMAP=fr-latin9" >> /etc/vconsole.conf
echo "FONT=eurlatgr" >>/etc/vconsole.conf
echo "arch-tsiry-laptop" >> /etc/hostname

# la ligne suivante modifie le fichier /etc/locale.gen à la ligne 248
sed -i '242s/.//' /etc/locale.gen
locale-gen


clear
echo "Ajouter un mot de passe de l'utilisateur root"
passwd root

# You can remove the tlp package if you are installing on a desktop or vm
clear
echo "Installation des paquets essentiels"
sleep 5

pacman -S --noconfirm networkmanager reflector xdg-user-dirs xdg-utils nfs-utils pipewire pipewire-docs pipewire-audio pipewire-alsa terminus-font zip unzip p7zip mc alsa-utils mtools dosfstools lsb-release ntfs-3g exfat-utils bash-completion neofetch htop ranger wpa_supplicant linux-lts-headers tlp lvm2

# open-vm-tools est à installer uniquement sur les machines virtuelles vmware
# ajouter le paquet tlp si installation sur un portable

pacman -S --noconfirm xf86-video-amdgpu

# si installation sur btrfs ne pas oublier d'ajouter dans le fichier /etc/mkinitcpio.conf, section MODULES, le mot btrfs
# si installation sur lvm, dans la section HOOK et avant filesystem, le mot lvm2 et ajouter dans la liste des paquets à installer lvm2
# clear	
# sleep 5
# mkinitcpio -p linux-lts

clear
sleep 5
# grub-install --no-floppy --recheck /dev/sda
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=arch_grub --recheck
mkdir /boot/efi/EFI/boot && cp /boot/efi/EFI/arch_grub/grubx64.efi /boot/efi/EFI/boot/bootx64.efi
grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable NetworkManager
systemctl enable tlp #si ordinateur portable

useradd -m rhtsiry

clear
echo "Ajouter le mot de passe de l'utilisateur rhtsiry"
passwd rhtsiry

usermod -aG audio,log,storage,users,video,wheel rhtsiry

echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers.d/rhtsiry

printf "N'OUBLIER PAS DE MODIFIER /etc/mkinitcpio.conf et de relancer mkinitcpio -p linux-lts avant de redemarrer"
