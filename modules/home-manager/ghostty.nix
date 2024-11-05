{ lib, ... }:
{
 config = {
xdg.configFile."ghostty/config".text = lib.generators.toKeyValue {
      mkKeyValue = lib.generators.mkKeyValueDefault { } " = ";
      listsAsDuplicateKeys = true;
    } {
      font-family = "FiraCode Nerd Font Mono";
      font-size = 12;
      # font-feature = [ "" ];

      theme = "catppuccin-mocha";
      minimum-contrast = "1.5";

      cursor-style = "block";

      window-padding-balance = true;

      resize-overlay = "never";

      quit-after-last-window-closed-delay = "1m";

      shell-integration-features = "sudo";
      
      gtk-single-instance = true;

      bold-is-bright = true;

      auto-update = "off";

      window-decoration = false;

      mouse-hide-while-typing = true;

      selection-foreground = "#071317";
      selection-background = "#ddeeff";

      cursor-invert-fg-bg = true;
    };
 };
}
