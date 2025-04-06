# hardware config
{
  config,
  lib,
  modulesPath,
  ...
}:

let
  hostname = config.networking.hostName;
in

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "ahci"
    "usb_storage"
    "usbhid"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  ### root
  fileSystems."/" = {
    device = "/dev/disk/by-label/NixOS";
    fsType = "btrfs";
    options = [ "subvol=/@" ];
  };

  ### nix
  fileSystems."/nix" = {
    device = "/dev/disk/by-label/NixOS";
    fsType = "btrfs";
    options = [ "subvol=/@nix" ];
  };

  ### home
  fileSystems."/home" = {
    device = "/dev/disk/by-label/NixOS";
    fsType = "btrfs";
    options = [ "subvol=/@home" ];
  };

  ### efi
  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-label/NIXOS-EFI";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
      "defaults"
    ];
  };

  ### NixOS
  fileSystems."/mnt/NixOS" = {
    device = "/dev/disk/by-label/NixOS";
    fsType = "btrfs";
    options = [ "subvol=/" ];
  };

  ### swap
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 4096;
    }
  ];

  fileSystems."/mnt/jtx-ssd" = lib.mkIf (hostname == "jtx-nixos" || hostname == "ffm-nixos") {
    device = "/dev/disk/by-label/jtx-ssd";
    fsType = "btrfs";
    options = [ "subvol=/" ];
  };

  fileSystems."/mnt/jtx-nvme" = lib.mkIf (hostname == "jtx-nixos") {
    device = "/dev/disk/by-label/jtx-nvme";
    fsType = "btrfs";
    options = [ "subvol=/" ];
  };

  ### bluetooth
  hardware.bluetooth.enable = lib.mkIf (hostname == "jtx-nixos") true;

  networking.useDHCP = lib.mkDefault true;

  hardware = {
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    keyboard.qmk.enable = true;
  };

}
