{
  device ? throw "Set this to your disk device, e.g. /dev/sda",
  swap ? throw "Set this to your expected swap size, e.g. 8G",
  ...
}: 
let
  swap_size = swap;
in
{
  disko.devices = {
    disk.main = {
      inherit device;
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            size = "512M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "defaults" "umask=0077" ];
            };
          };
          swap = {
            size = swap_size;
            content = {
              type = "swap";
              resumeDevice = true;
            };
          };
          root = {
            size = "100%";
            type = "8300"; # linux file system
            content = {
              type = "btrfs";
              subvolumes = {
                "/root" = {
                  mountOptions = 
                    [ "compress=zstd" ]; # compression for better performance
                  mountpoint = "/";
                };
                "/persistent" = {
                  mountOptions = 
                    [ "compress=zstd" ];
                  mountpoint = "/persistent";
                };
                "/nix" = {
                  mountOptions = 
                    [ "compress=zstd" "noatime" "noacl" ]; # optimize for nix store
                  mountpoint = "/nix";
                };
              };
            };
          };
        };
      };
    };
  };
}
