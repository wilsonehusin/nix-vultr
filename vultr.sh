#!/bin/sh
# Inspired by https://eipi.xyz/vultr.sh
# Install NixOS on a Vultr VPS

umount /dev/vda*

# create partitions (with 2G swap)
(
echo g

# swap
echo n
echo
echo
echo +2GB
echo t
echo
echo 19

# bios boot (for grub)
echo n
echo
echo
echo +16MB
echo t
echo
echo 4

# /
echo n
echo
echo
echo

echo w
) | fdisk /dev/vda

fdisk -l /dev/vda

# enable swap
mkswap -f /dev/vda1
swapon /dev/vda1
free -h

# wait
sleep 5

# create filesystem and mount
mkfs.ext4 /dev/vda3 -Lroot
mount /dev/vda3 /mnt

# generate NixOS config
root_password=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 64 | head -n 1)
nixos-generate-config --root /mnt
echo "System configuration.nix:"
tee /mnt/etc/nixos/configuration.nix << EOF
{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  environment.systemPackages = with pkgs; [
    vim
  ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/vda";

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.permitRootLogin = "yes";

  users.users.root = {
    password = "$root_password";
    openssh.authorizedKeys.keys = ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCmOQ/koFIJKXFOrT/qYtF2UFtwv7mNKk6iSXTxlvbS21XqPiBx7NhqNrZ8ODunn9pn2L3lzxpTHmLOoAc2lFGGo6FoUGazv8lBWKQDgQIg5ZHhw2kHffcKpHhuQ4MgmkumCgv++ELMbEcZi7SsXQpjCk9dJqfE/hmz482035TnkpKxV6LED4hj98nnBL61WdgT98uYGa6RJKgK9EsEV/v4dFoUapciiTQ9dhmnxTGQL3c4nqmsmri4t+pYXAxNeAh8f/Rj9X0MblCZVZZVgE8ZmRB2J15/J8xF0fQCkhZ3bzR1D91ubIJmk0gZSvRbEH8S89KrnFIrCzp8twD/NbJqA+IdMc3dUphYIIWaLPthJSbl2+r+rFCDLXuvelOu+FIhseeBU1YYIeYg0OEyPUmkivGIURrodDSqo+LO8anZSpxS8Mkh245Vgbbthg76URaftRjVcIe4DU/qFe220C14e3B9ouOl58BBt1Vy9neB4GqROFkXbxd4/yyyfMRlnaeA9YGkrY0hFmwvkYmcpk8Q25PBUzKJ1cs/VtLnAOHjHFRwF9N3gJaO4lS34HzwQi5WpVtdqrU6h9sY0fv65boH85DOWihII9hxFDa5kjll4ZNHz5OosqW2QRDdoFu7bcnPUWPDurMspQ5f2nrmNoMU0jopCrndDvwNStKoIGBgZQ== wilson@t480"];
  };

  system.stateVersion = "19.03";
}
EOF

# install NixOS
nixos-install

# unmount
sync
umount /dev/vda3

echo "Done. Now reboot via \"Remove ISO\" on the Vultr web UI."
