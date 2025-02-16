{ lib, ...}:
{
  imports = [
  ../common/optional/ephemeral-btrfs.nix
  ../common/optional/disko-btrfs.nix
  ../../modules/btrfs.nix
  ];

  boot = {
    initrd = {
      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "ahci"
        "usb_storage"
        "usbhid"
        "sd_mod"      ];
      kernelModules = ["kvm-amd"];
    };
  loader = {
      systemd-boot = {
        enable = true;
        consoleMode = "max";
      };
      efi.canTouchEfiVariables = true;
    };
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/ESP";
    fsType = "vfat";
  };

  swapDevices = [ { device = "/swap/swapfile"; } ];

  hardware.cpu.amd.updateMicrocode = true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
