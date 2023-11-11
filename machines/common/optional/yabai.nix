{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ yabai ];

  services.yabai = {
    enable = true;
    enableScriptingAddition = true;
    config = {
      focus_follows_mouse = "off";
      mouse_follows_focus = "off";
      window_origin_display = "default";
      window_placement = "second_child";
      window_zoom_persist = "on";
      window_topmost = "off";
      window_shadow = "on";
      window_opacity = "off";
      window_opacity_duration = 0;
      active_window_opacity = 1;
      normal_window_opacity = 0.9;
      window_animation_duration = 0;
      window_animation_frame_rate = 120;
      insert_feedback_color = "0xffd75f5f";
      active_window_border_color = "0xff775759";
      normal_window_border_color = "0xff555555";
      window_border_width = 4;
      window_border_radius = 12;
      window_border_blur = "off";
      window_border_hidpi = "on";
      window_border = "off";
      split_ratio = 0.5;
      split_type = "auto";
      auto_balance = "off";
      top_padding = 10;
      bottom_padding = 10;
      left_padding = 10;
      right_padding = 10;
      window_gap = 10;
      layout = "bsp";
      mouse_modifier = "fn";
      mouse_action1 = "move";
      mouse_action2 = "resize";
      mouse_drop_action = "swap";
    };
    extraConfig = ''
      # apps to not manage (ignore)
      yabai -m rule --add app="^System Settings$" manage=off
      yabai -m rule --add app="^Archive Utility$" manage=off
      yabai -m rule --add app="^Notes$" manage=off
      # yabai -m rule --add app="^Wally$" manage=off
      # yabai -m rule --add app="^Pika$" manage=off
      # yabai -m rule --add app="^balenaEtcher$" manage=off
      # yabai -m rule --add app="^Creative Cloud$" manage=off
      # yabai -m rule --add app="^Logi Options$" manage=off
      # yabai -m rule --add app="^Alfred Preferences$" manage=off
      # yabai -m rule --add app="Raycast" manage=off
      # yabai -m rule --add app="^Music$" manage=off
    '';
  };
}
