{ lib, ... }:
{
  config = {
    xdg.configFile."ghostty/config".text =
      lib.generators.toKeyValue
        {
          mkKeyValue = lib.generators.mkKeyValueDefault { } " = ";
          listsAsDuplicateKeys = true;
        }
        {
          font-family = "FiraCode Nerd Font Mono";
          font-size = 12;
          # font-feature = [ "" ];

          theme = "Catppuccin Mocha";

          # Causes some issues with box rendering
          # minimum-contrast = "1.5";

          cursor-style = "block";

          window-padding-balance = true;

          resize-overlay = "never";

          quit-after-last-window-closed-delay = "1m";

          shell-integration-features = "sudo";

          gtk-single-instance = true;
          window-decoration = false;

          bold-is-bright = true;

          auto-update = "off";

          mouse-hide-while-typing = true;

          selection-foreground = "#071317";
          selection-background = "#ddeeff";

          cursor-invert-fg-bg = true;

          background-opacity = "0.85";
          background-blur-radius = 20;

          keybind = [
            # Clipboard :)
            "ctrl+shift+c=copy_to_clipboard"
            "ctrl+shift+v=paste_from_clipboard"

            # Selection
            "ctrl+shift+a=select_all"

            # Never worked, and fucks up my typing
            # "shift+h=adjust_selection:right"
            # "shift+j=adjust_selection:down"
            # "shift+k=adjust_selection:up"
            # "shift+l=adjust_selection:left"

            # Font size
            "ctrl+plus=increase_font_size:1"
            "ctrl+equal=increase_font_size:1"
            "ctrl+minus=decrease_font_size:1"
            "ctrl+zero=reset_font_size"

            # Navigation
            "ctrl+home=scroll_to_top"
            "ctrl+end=scroll_to_bottom"

            "ctrl+shift+u=scroll_page_up"
            "ctrl+shift+d=scroll_page_down"

            "ctrl+shift+page_down=jump_to_prompt:1 "
            "ctrl+shift+page_up=jump_to_prompt:-1"

            # Splits
            ## Creating splits
            "ctrl+shift+o=new_split:right"
            "ctrl+shift+i=new_split:down"

            ## Moving between splits
            "super+ctrl+right_bracket=goto_split:next"
            "super+ctrl+left_bracket=goto_split:previous"

            "ctrl+alt+h=goto_split:left"
            "ctrl+alt+j=goto_split:bottom"
            "ctrl+alt+k=goto_split:top"
            "ctrl+alt+l=goto_split:right"

            ## Resizing splits
            "ctrl+alt+equal=equalize_splits"

            "super+ctrl+shift+h=resize_split:left,10"
            "super+ctrl+shift+j=resize_split:down,10"
            "super+ctrl+shift+k=resize_split:up,10"
            "super+ctrl+shift+l=resize_split:right,10"

            # Miscelaneous
            ## Clear screen
            "super+ctrl+c=clear_screen"

            ## Scrollback file
            "ctrl+shift+s=write_scrollback_file:paste"

            ## Inspector
            "ctrl+alt+shift+i=inspector:toggle"

            ## Close surface
            "ctrl+shift+w=close_surface"

            ## Reload config
            "ctrl+shift+comma=reload_config"

            # Unbound defaults
            "ctrl+comma=unbind"
            "ctrl+alt+shift+j=unbind"
            "ctrl+shift+n=unbind"
            "ctrl+shift+t=unbind"
            "ctrl+shift+left=unbind"
            "ctrl+page_down=unbind"
            "alt+one=unbind"
            "alt+two=unbind"
            "alt+three=unbind"
            "alt+four=unbind"
            "alt+five=unbind"
            "alt+six=unbind"
            "alt+seven=unbind"
            "alt+eight=unbind"
            "alt+nine=unbind"
            "shift+insert=unbind"
            "ctrl+shift+enter=unbind"
            "ctrl+shift+j=unbind"
            "ctrl+enter=unbind"
            "ctrl+page_up=unbind"
            "ctrl+tab=unbind"
            "ctrl+shift+right=unbind"
            "ctrl+shift+tab=unbind"
            "alt+f4=unbind"
            "ctrl+shift+q=unbind"
            "super+ctrl+shift+left=unbind"
            "super+ctrl+shift+down=unbind"
            "super+ctrl+shift+up=unbind"
            "super+ctrl+shift+right=unbind"
            "super+ctrl+right_bracket=unbind"
            "super+ctrl+left_bracket=unbind"
            "ctrl+alt+left=unbind"
            "ctrl+alt+down=unbind"
            "ctrl+alt+up=unbind"
            "ctrl+alt+right=unbind"
            "shift+left=unbind"
            "shift+down=unbind"
            "shift+up=unbind"
            "shift+right=unbind"
            "shift+page_up=unbind"
            "shift+page_down=unbind"
          ];

        };
  };
}
