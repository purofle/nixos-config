{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./base.nix
    ./i18n.nix
    ./font.nix
    ./packages.nix
  ];

  networking.hostName = "nixos";

  boot = {
    kernelParams = [ "pcie_port_pm=off" ];
    loader = {
      grub = {
        enable = true;
        efiSupport = true;
        configurationLimit = 3;
        device = "nodev";
        useOSProber = true;
      };
      efi = {
        canTouchEfiVariables = true;
      };
    };
  };

  # 指纹识别
  services.fprintd.enable = true;

  # Intel 核显驱动
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
    ];
  };

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 4 * 1024; # 4 GB
    }
  ];
}
