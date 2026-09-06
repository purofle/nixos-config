{ pkgs, ... }:

{
  boot = {
    binfmt = {
      emulatedSystems = [ "riscv64-linux" ];
      preferStaticEmulators = true;
    };
    kernelPackages = pkgs.linuxPackages_zen;
  };

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
      discord
      blender
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
