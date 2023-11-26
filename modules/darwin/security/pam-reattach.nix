{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.security.pam;

  mkPamReattachScript = isEnabled:
  let
    file   = "/etc/pam.d/sudo";
    option = "security.pam.reattach";
    sed = "${pkgs.gnused}/bin/sed";
  in ''
    ${if isEnabled then ''
      # If enable and in file, remove and re-add in case the store path has
      # changed
      if grep '${option}' ${file} > /dev/null; then
        ${sed} -i '/${option}/d' ${file}
      fi

      ${sed} -i '2i\
      auth       optional       ${pkgs.pam-reattach}/lib/pam/pam_reattach.so ignore_ssh # nix-darwin: ${option}
      ' ${file}
    '' else ''
      # Disable pam_reattach, if added by nix-darwin
      if grep '${option}' ${file} > /dev/null; then
        ${sed} -i '/${option}/d' ${file}
      fi
    ''}
  '';
in

{
  options = {
    security.pam.enablePamReattach = mkEnableOption "" // {
      description = lib.mdDoc ''
        Enable pam_reattach sudo authentication with Touch ID in tmux/screen.

        When enabled, this option adds the following line to
        {file}`/etc/pam.d/sudo`:

        ```
        auth       optional     pam_reattach.so ignore_ssh
        ```

        ::: {.note}
        macOS resets this file when doing a system update. As such,
        pam_reattach won't work after a system update
        until the nix-darwin configuration is reapplied.
        :::
      '';
    };
  };

  config = {
    environment.systemPackages =
      mkIf cfg.enablePamReattach [ pkgs.pam-reattach ];

    system.activationScripts.pam.text = ''
      # PAM settings
      echo >&2 "setting up pam..."
      ${mkPamReattachScript cfg.enablePamReattach}
    '';
  };
}
