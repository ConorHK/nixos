{...}: {
  disko.devices = {
    disk.main = {
      device = "/dev/sda";
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
            size = "8G";
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
