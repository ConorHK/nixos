#!/bin/sh
set -o errexit
set -o nounset
set -o pipefile

info() { printf "$(tput setaf 6)%s $(tput setaf 4)%s$(tput sgr0)\n" "$*" >&2; }

function yesno() {
    local prompt="$1"

    while true; do
        read -rp "$prompt [y/n] " yn
        case $yn in
            [Yy]* ) echo "y"; return;;
            [Nn]* ) echo "n"; return;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}

cat << Introduction
The *entire* disk with be formatted with a 1GB boot partition
(labelled NIXBOOT), 16GB of swap, and the rest allocated to BTRFS.

This setup is assuming you will utilize the impermanence nix module.

Introduction

info "Getting disko config"
curl -L https://raw.githubusercontent.com/conorhk/ndots/mainline/disko.nix -o /tmp/disko.nix

lsblk

# Get the list of disks
mapfile -t disks < <(lsblk -ndo NAME,SIZE,MODEL)

echo -e "\nAvailable disks:\n"
for i in "${!disks[@]}"; do
printf "%d) %s\n" $((i+1)) "${disks[i]}"
done

# Get user selection
while true; do
echo ""
read -rp "Enter the number of the disk to install to: " selection
if [[ "$selection" =~ ^[0-9]+$ ]] && [ "$selection" -ge 1 ] && [ "$selection" -le ${#disks[@]} ]; then
    break
else
    echo "Invalid selection. Please try again."
fi
done

# Get the selected disk
disk="/dev/$(echo "${disks[$selection-1]}" | awk '{print $1}')"

echo ""
do_format=$(yesno "This irreversibly formats the entire disk. Are you sure?")
if [[ $do_format == "n" ]]; then
    exit
fi

free -h
read -rp "Select a swap size, this should be equal to GB of RAM" swap_size

nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko /tmp/disko.nix --arg device "'$disk'" --arg swap "'$swap_size'"

info "Generating NixOS config at /mnt"
nixos-generate-config --no-filesystems --root /mnt

info "Getting rest of nix config and placing at /mnt/etc/nixos"
curl https://raw.githubusercontent.com/conorhk/nixos/refs/heads/mainline/configuration.nix -o /mnt/etc/nixos/configuration.nix
curl https://raw.githubusercontent.com/conorhk/nixos/refs/heads/mainline/flake.nix -o /mnt/etc/nixos/flake.nix
curl https://raw.githubusercontent.com/conorhk/nixos/refs/heads/mainline/home.nix -o /mnt/etc/nixos/home.nix
cp /tmp/disko.nix /mnt/etc/nixos/disko.nix

info "Installing config"

nixos-install --root /mnt --flake /mnt/etc/nixos#default

info "Copying config to persistent directory"
cp -r /mnt/etc/nixos/* /mnt/persistent/etc/nixos/
