{ inputs, lib, pkgs, ... }:
{
  imports = [
    inputs.raspberry-pi-nix.nixosModules.raspberry-pi

    ../common/global

    ../common/optional/cachix.nix
    ../common/optional/fish.nix
    ../common/optional/fonts.nix
    ../common/optional/gnupg.nix
    ../common/optional/nixos.nix
    ../common/optional/openssh.nix

    ../common/users/thomas
    ../common/users/thomas/authorized_keys.nix
    ../common/users/thomas/groups.nix
    ../common/users/thomas/nixos.nix
  ];

  # nixpkgs.buildPlatform = "aarch64-darwin";
  nixpkgs.hostPlatform = "aarch64-linux";
  raspberry-pi-nix.board = "bcm2711";
  # hardware = {
  #   bluetooth.enable = false;
  #   raspberry-pi = {
  #     config = {
  #       all = {
  #         base-dt-params = {
  #           # enable autoprobing of bluetooth driver
  #           # https://github.com/raspberrypi/linux/blob/c8c99191e1419062ac8b668956d19e788865912a/arch/arm/boot/dts/overlays/README#L222-L224
  #           krnbt = {
  #             enable = true;
  #             value = "on";
  #           };
  #         };
  #       };
  #     };
  #   };
  # };

  networking.hostName = "odin";
  time.timeZone = "Europe/Vienna";
  i18n.defaultLocale = "en_US.UTF-8";
  users.mutableUsers = false;
  system.stateVersion = "24.05";
}
