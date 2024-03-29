{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.hardware.geekworm-xscript;
in
{
  options = {
    hardware.geekworm-xscript = {
      fan.enable = mkEnableOption "Enable Fan Control";
      pwr.enable = mkEnableOption "Enable Hardware Power Management";

      package = mkOption {
        type = types.package;
        default = pkgs.geekworm-xscript;
        defaultText = literalExpression "pkgs.geekworm-xscript";
        example = literalExpression "pkgs.geekworm-xscript-custom";
        description = mdDoc ''
          Which geekworm-xscript package to use.
        '';
      };
    };
  };

  config = mkMerge [
    (mkIf cfg.fan.enable or cfg.pwr.enable {
      environment.systemPackages = [ cfg.package ];
    })

    (mkIf cfg.fan.enable {
      systemd.services.geekworm-xscript-fan = {
        description = "Daemon to monitor and control fan speed";
        wantedBy = [ "multi-user.target" ];

        serviceConfig = {
          Restart = "always";
          Type = "simple";
          ExecStart = "${cfg.package}/bin/x-c1-fan.sh";
        };
      };

      hardware.deviceTree = {
        overlays = [{
          name = "pwm-2chan-overlay";
          dtsText = ''
            /dts-v1/;
            /plugin/;

            /*
            This is the 2-channel overlay - only use it if you need both channels.

            Legal pin,function combinations for each channel:
              PWM0: 12,4(Alt0) 18,2(Alt5) 40,4(Alt0)            52,5(Alt1)
              PWM1: 13,4(Alt0) 19,2(Alt5) 41,4(Alt0) 45,4(Alt0) 53,5(Alt1)

            N.B.:
              1) Pin 18 is the only one available on all platforms, and
                 it is the one used by the I2S audio interface.
                 Pins 12 and 13 might be better choices on an A+, B+ or Pi2.
              2) The onboard analogue audio output uses both PWM channels.
              3) So be careful mixing audio and PWM.
            */

            / {
              compatible = "brcm,bcm2711";

              fragment@0 {
                target = <&gpio>;
                __overlay__ {
                  pwm_pins: pwm_pins {
                    brcm,pins = <18 19>;
                    brcm,function = <2 2>; /* Alt5 */
                  };
                };
              };

              fragment@1 {
                target = <&pwm>;
                frag1: __overlay__ {
                  pinctrl-names = "default";
                  pinctrl-0 = <&pwm_pins>;
                  assigned-clock-rates = <100000000>;
                  status = "okay";
                };
              };

              __overrides__ {
                pin   = <&pwm_pins>,"brcm,pins:0";
                pin2  = <&pwm_pins>,"brcm,pins:4";
                func  = <&pwm_pins>,"brcm,function:0";
                func2 = <&pwm_pins>,"brcm,function:4";
                clock = <&frag1>,"assigned-clock-rates:0";
              };
            };
            '';
        }];
      };
    })

    (mkIf cfg.pwr.enable {
      systemd.services.geekworm-xscript-pwr = {
        description = "Run Hardware Power Management & Safe Shutdown daemon";
        wantedBy = [ "multi-user.target" ];

        serviceConfig = {
          Restart = "always";
          Type = "simple";
          ExecStart = "${cfg.package}/bin/x-c1-pwr.sh";
        };
      };
    })
  ];
}
