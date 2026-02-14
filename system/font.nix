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
      localConf = ''
        <match target="font">
          <test name="family" qual="first">
            <string>Noto Color Emoji</string>
          </test>
          <edit name="antialias" mode="assign">
            <bool>false</bool>
          </edit>
        </match>
      '';
      defaultFonts = {
        emoji = [
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
