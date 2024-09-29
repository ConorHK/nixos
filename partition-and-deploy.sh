#!/bin/sh

curl https://raw.githubusercontent.com/conorhk/nixos/refs/heads/mainline/disko.nix -o /tmp/disko.nix
nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko /tmp/disko.nix --arg device '"/dev/sda"'

nixos-generate-config --no-filesystems --root /mnt
curl https://raw.githubusercontent.com/conorhk/nixos/refs/heads/mainline/configuration.nix -o /mnt/persist/nixos/
curl https://raw.githubusercontent.com/conorhk/nixos/refs/heads/mainline/flake.nix -o /mnt/persist/nixos/
curl https://raw.githubusercontent.com/conorhk/nixos/refs/heads/mainline/home.nix -o /mnt/persist/nixos/
curl https://raw.githubusercontent.com/conorhk/nixos/refs/heads/mainline/disko.nix -o /mnt/persist/nixos/
nixos-install --root /mnt --flake /mnt/etc/nixos#default
