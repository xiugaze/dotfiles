# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { 
      device = "/dev/disk/by-uuid/2357c214-1a5b-49eb-8581-c5764c921cd5";
      # label = "root";
      fsType = "ext4";
      options = [
        "x-gvfs-show"
      ];
    };

  fileSystems."/boot" =
    { 
      device = "/dev/disk/by-uuid/8247-BAA9";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  fileSystems."/mnt/windows" =
    { device = "/dev/nvme1n1p2";
      # label = "windows";
      fsType = "ntfs-3g";
      options = [ 
        "nofail"
        "x-gvfs-show"
        "rw" 
        "uid=caleb" 
      ];
    };

  fileSystems."/mnt/data" =
    { device = "/dev/sdb1";
      fsType = "ntfs-3g";
      # label = "data";
      options = [ 
        "nofail"
        "x-gvfs-show"
        "rw" 
        "uid=caleb" 
      ];
    };
  fileSystems."/mnt/games" =
    { device = "/dev/sda1";
      # label = "games";
      fsType = "ntfs-3g";
      options = [ 
        "nofail"
        "x-gvfs-show"
        "rw" 
        "uid=caleb" 
      ];
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/b7d78f75-ef3c-42d3-8552-d577a75a176e"; }
    ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp6s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp5s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
