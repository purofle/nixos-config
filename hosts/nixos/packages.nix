{ pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    lm_sensors
    s-tui
    gparted
    usbutils
    qemu-user
    nvtopPackages.intel
    pciutils
    sbctl
    qemu
    bubblewrap
    android-tools
    wechat-uos
    nur.repos.ccicnce113424.splayer-next-dev
    osu-lazer-bin
    xmind
    cisco-packet-tracer_9
    wpsoffice-cn
    feishu
    gnucash
  ];
}
