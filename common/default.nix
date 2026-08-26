{
  imports = [
    ./fonts.nix
    ./packages.nix
  ];
  nix.settings = {
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
    auto-optimise-store = true;
  };

  nixpkgs.config.allowUnfree = true;
  time.timeZone = "Asia/Shanghai";
}
