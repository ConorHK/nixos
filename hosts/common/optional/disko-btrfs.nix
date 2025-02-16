{ config, lib, os_disk ? "/dev/nvme0n1", ... }: let
  inherit (lib) mkIf;
  hostname = config.networking.hostName;
in {
  disko.devices = {
    disk.main = {
      type = "disk";
      device = os_disk;
      imageSize = "50G"; # Disk size when running as VM

      content = {
        type = "gpt";
        partitions.ESP = {
          priority = 1;
          type = "EF00";
          start = "1M";
          end = "128M";
          label = "ESP";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            extraArgs = [ "-n" "ESP" ];
            mountOptions = [ "umask=0077" ];
          };
        };
        content = {
          type = "btrfs";
          extraArgs = [ "-f" "-L" "NIXOS" ];
          subvolumes = let
            mountOptions = [ "compress=zstd" "noatime" "ssd" "autodefrag" "discard=async" ];
          in {
            "root"     = { mountpoint = "/";        inherit mountOptions; };
            "nix"      = { mountpoint = "/nix";     inherit mountOptions; };
            "persist"  = { mountpoint = "/persist"; inherit mountOptions; };
            "log"      = { mountpoint = "/var/log"; inherit mountOptions; };
            "swap" = {
              mountpoint = "/swap";
              mountOptions = [ "subvol=swap" "noatime" ];
              swap.swapfile.size = "4G";
            };
          };
        };
      };
    };
  };
  fileSystems."/persist".neededForBoot = mkIf config.impermanence.enable true;
  fileSystems."/var/log".neededForBoot = true;
  fileSystems."/swap".neededForBoot = true;
}
