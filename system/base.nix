{ pkgs, inputs, ... }:

{
  boot = {
    kernelParams = [ "pcie_port_pm=off" ];
    loader = {
      limine = {
        enable = true;
        secureBoot.enable = true;
        maxGenerations = 3;
        extraEntries = ''
          /Windows 11
            protocol: efi
            path: guid(e8c6be0b-a907-4969-9bae-6aa070852079):/EFI/Microsoft/Boot/bootmgfw.efi
        '';
        style = {
          wallpapers = [ "/home/purofle/Pictures/wallpaper.jpg" ];
          interface = {
            resolution = "2560x1440";
            helpHidden = true;
            branding = "Purofle's computer";
            brandingColor = 6;
          };
        };
      };
      efi = {
        canTouchEfiVariables = true;
      };
    };
    binfmt = {
      emulatedSystems = [ "riscv64-linux" ];
      preferStaticEmulators = true;
    };
    kernelPackages = pkgs.linuxPackages_zen;
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
      options = "--delete-older-than 14d";
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

  nixpkgs.overlays = [
    (final: prev: {
      wechat-uos = (import inputs.wechat-4114 {
        system = prev.system;
        config.allowUnfree = true;
      }).wechat-uos;
    })
  ];

  users.users.purofle = {
    isNormalUser = true;
    description = "purofle";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
    packages = with pkgs; [
      kdePackages.kate
      kdePackages.kdeconnect-kde
      telegram-desktop
      nil
      vlc
      mpv
      ghidra
      google-chrome
      wechat-uos
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAjbiKTIcKZZqETsz7EOo8xsYN07u+5q6xSSdlkwUqU8"
    ];
  };

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
    ];
  };

  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  # Install firefox.
  programs.firefox.enable = true;

  programs.nix-ld.enable = true;

  programs.steam.enable = true;

  programs.obs-studio = {
    enable = true;
    enableVirtualCamera = true;
    plugins = with pkgs.obs-studio-plugins; [
      obs-vaapi
    ];
  };

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
    lm_sensors
    s-tui
    gparted
    dust
    file
    usbutils
    qemu-user
    nvtopPackages.intel
    pciutils
    sbctl
  ];

  virtualisation.docker = {
    enable = true;
  };

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 4 * 1024; # 4 GB
    }
  ];

  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
  };

  services.openssh.enable = true;

  networking.firewall.enable = false;
}
