#!/bin/sh

curl https://raw.githubusercontent.com/conorhk/nixos/refs/heads/mainline/disko.nix -o /tmp/disko.nix
nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko /tmp/disko.nix --arg device '"/dev/sda"' --arg swap '"8G"'

nixos-generate-config --no-filesystems --root /mnt
curl https://raw.githubusercontent.com/conorhk/nixos/refs/heads/mainline/configuration.nix -o /mnt/etc/nixos/configuration.nix
curl https://raw.githubusercontent.com/conorhk/nixos/refs/heads/mainline/flake.nix -o /mnt/etc/nixos/flake.nix
curl https://raw.githubusercontent.com/conorhk/nixos/refs/heads/mainline/home.nix -o /mnt/etc/nixos/home.nix
curl https://raw.githubusercontent.com/conorhk/nixos/refs/heads/mainline/disko.nix -o /mnt/etc/nixos/disko.nix
nixos-install --root /mnt --flake /mnt/etc/nixos#default
