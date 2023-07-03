{ pkgs, ... }:
{
  home.packages = with pkgs; [ alacritty ];

  programs.alacritty = {
    enable = true;

    settings = {
      env = {
        LC_ALL = "en_US.UTF-8";
        LC_CTYPE = "en_US.UTF-8";
        TERM = "xterm-256color";
      };

      TERM = "alacritty";

      font = {
        normal = {
          family = "FiraCode Nerd Font";
          style = "Regular";
        };
        bold = {
          family = "FiraCode Nerd Font";
          style = "Bold";
        };
        italic = {
          family = "FiraCode Nerd Font";
          style = "Italic";
        };
        bold_italic = {
          family = "FiraCode Nerd Font";
          style = "Bold Italic";
        };
        size = 11.0;
      };

      # Colors (Iceberg Dark)
      colors = {
        # Default colors
        primary = {
          background = "#161821";
          foreground = "#d2d4de";
        };

        # Normal colors
        normal = {
          black = "#161821";
          red = "#e27878";
          green = "#b4be82";
          yellow = "#e2a478";
          blue = "#84a0c6";
          magenta = "#a093c7";
          cyan = "#89b8c2";
          white = "#c6c8d1";
        };

        # Bright colors
        bright = {
          black = "#6b7089";
          red = "#e98989";
          green = "#c0ca8e";
          yellow = "#e9b189";
          blue = "#91acd1";
          magenta = "#ada0d3";
          cyan = "#95c4ce";
          white = "#d2d4de";
        };
      };

      bell = {
        animation = "EaseOutExpo";
        duration = 400;
        color = "#ffffff";
      };

      window = {
        #decorations = "None";
        padding = {
          x = 12;
          y = 12;
        };
        opacity = 0.8;
      };

      shell = {
        program = "${pkgs.fish}/bin/fish";
        args = [ "--login" ];
      };

      key_bindings = [
       { key = "Space"; mods = "Shift"; mode = "~Search"; action = "ToggleViMode"; }

        # TODO: figure out why I set these
        # { key = "Up"; mods = "Alt"; chars = "\x1b[1;5A"; }
        # { key = "Down"; mods = "Alt"; chars = "\x1b[1;5B"; }
        # { key = "Left"; mods = "Alt"; chars = "\x1bb"; }
        # { key = "Right"; mods = "Alt"; chars = "\x1bf"; }
        # { key = "A"; mods = "Alt"; chars = "\x1ba"; }
        # { key = "B"; mods = "Alt"; chars = "\x1bb"; }
        # { key = "C"; mods = "Alt"; chars = "\x1bc"; }
        # { key = "D"; mods = "Alt"; chars = "\x1bd"; }
        # { key = "E"; mods = "Alt"; chars = "\x1be"; }
        # { key = "F"; mods = "Alt"; chars = "\x1bf"; }
        # { key = "G"; mods = "Alt"; chars = "\x1bg"; }
        # { key = "H"; mods = "Alt"; chars = "\x1bh"; }
        # { key = "I"; mods = "Alt"; chars = "\x1bi"; }
        # { key = "J"; mods = "Alt"; chars = "\x1bj"; }
        # { key = "K"; mods = "Alt"; chars = "\x1bk"; }
        # { key = "L"; mods = "Alt"; chars = "\x1bl"; }
        # { key = "M"; mods = "Alt"; chars = "\x1bm"; }
        # { key = "N"; mods = "Alt"; chars = "\x1bn"; }
        # { key = "O"; mods = "Alt"; chars = "\x1bo"; }
        # { key = "P"; mods = "Alt"; chars = "\x1bp"; }
        # { key = "Q"; mods = "Alt"; chars = "\x1bq"; }
        # { key = "R"; mods = "Alt"; chars = "\x1br"; }
        # { key = "S"; mods = "Alt"; chars = "\x1bs"; }
        # { key = "T"; mods = "Alt"; chars = "\x1bt"; }
        # { key = "U"; mods = "Alt"; chars = "\x1bu"; }
        # { key = "V"; mods = "Alt"; chars = "\x1bv"; }
        # { key = "W"; mods = "Alt"; chars = "\x1bw"; }
        # { key = "X"; mods = "Alt"; chars = "\x1bx"; }
        # { key = "Y"; mods = "Alt"; chars = "\x1by"; }
        # { key = "Z"; mods = "Alt"; chars = "\x1bz"; }
        # { key = "Key0"; mods = "Alt"; chars = "º"; }
        # { key = "Key1"; mods = "Alt"; chars = "¡"; }
        # { key = "Key2"; mods = "Alt"; chars = "€"; }
        # { key = "Key3"; mods = "Alt"; chars = "#"; }
        # { key = "Key4"; mods = "Alt"; chars = "¢"; }
        # { key = "Key5"; mods = "Alt"; chars = "∞"; }
        # { key = "Key6"; mods = "Alt"; chars = "§"; }
        # { key = "Key7"; mods = "Alt"; chars = "¶"; }
        # { key = "Key8"; mods = "Alt"; chars = "•"; }
        # { key = "Key9"; mods = "Alt"; chars = "ª"; }
      ];

      mouse = { hints = { launcher= "None"; }; };
    };
  };
}
