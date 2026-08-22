{ pkgs, inputs, ... }:

{
  boot = {
    binfmt = {
      emulatedSystems = [ "riscv64-linux" ];
      preferStaticEmulators = true;
    };
    kernelPackages = pkgs.linuxPackages_zen;
  };

  nix = {
    settings = {
      substituters = [
        "https://mirrors.ustc.edu.cn/nix-channels/store"

        "https://cache.nixos.org"
      ];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "purofle"
        "root"
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

  networking.networkmanager.enable = true;

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
      "docker"
      "libvirtd"
    ];
    packages = with pkgs; [
      kdePackages.kate
      kdePackages.kdeconnect-kde
      kdePackages.krdc
      telegram-desktop
      nil
      vlc
      mpv
      ghidra
      google-chrome
      qq
      eden
      typst
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAjbiKTIcKZZqETsz7EOo8xsYN07u+5q6xSSdlkwUqU8"
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
    qemu
    bubblewrap
    android-tools
    doggo
    wechat
    nur.repos.ccicnce113424.splayer-next-dev
  ];

  virtualisation = {
    docker.enable = true;
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu;
        runAsRoot = true;
        swtpm.enable = true;
      };
    };
  };

  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
  };

  services.openssh.enable = true;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    nssmdns6 = true;
    openFirewall = true;
    publish = {
      enable = true;
      userServices = true;
      addresses = true;
    };
  };

  networking.firewall.enable = false;
}
