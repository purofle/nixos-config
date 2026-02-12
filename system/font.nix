{ pkgs, ... }:
{
  fonts = {
    packages = with pkgs; [
      sarasa-gothic
      nerd-fonts.jetbrains-mono
      jetbrains-mono
      source-han-serif
      source-han-sans
      noto-fonts-color-emoji
    ];

    fontconfig = {
      defaultFonts = {
        emoji = [
          "JetBrainsMono Nerd Font"
          "Noto Color Emoji"
        ];
        monospace = [
          "JetBrainsMono Nerd Font Mono"
          "Sarasa Mono SC"
        ];
        sansSerif = [ "Sarasa Gothic SC" ];
        serif = [ "Source Han Serif SC" ];
      };
      cache32Bit = true;
    };
  };
}