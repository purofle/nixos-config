{ pkgs, ... }:

{
  boot = {
    loader = {
      grub = {
        enable = true;
        efiSupport = true;
        configurationLimit = 3;
        useOSProber = true;
        device = "nodev";
      };
      efi = {
        canTouchEfiVariables = true;
      };
    };
  };

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      # 感觉可能有用
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      options = "--delete-older-than 3d";
      dates = "daily";
    };
  };

  time.timeZone = "Asia/Shanghai";
  system.stateVersion = "25.11";

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  services.fprintd.enable = true;
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.daed = {
    enable = true;
  };

  users.users.purofle = {
    isNormalUser = true;
    description = "purofle";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [
      kdePackages.kate
      pkgs.kdePackages.kdeconnect-kde
      telegram-desktop
      nil
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "purofle" ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    nixfmt
    nil
    helix
    gnupg
    htop
    bat
    eza
    vscode
  ];
  
  swapDevices = [{
  device = "/var/lib/swapfile";
  size = 4*1024; # 4 GB
}];

  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
  };

  services.openssh.enable = true;

  networking.firewall.enable = false;
}
