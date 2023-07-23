{ config, pkgs, ... }:
{
  sdImage = {
    imageName = "nixos.img";
    compressImage = false;
  };

  services.tor = {
    enable = true;
    settings = {
      HiddenServiceDir = "/var/lib/tor/ssh";
      HiddenServicePort = "22 127.0.0.1:22";
    };
  };

  systemd.services.notify = {
    enable = true;
    description = "Notify Me";
    wantedBy = [ "tor.service" ];
    after = [ "tor.service" ];
    requires = [ "network-online.target" ];
    restartIfChanged = false;
    unitConfig.X-StopOnRemoval = false;
    script = ''
      #!${pkgs.runtimeShell} -eu

      hostname=`cat /var/lib/tor/ssh/hostname`
      ${pkgs.curl}/bin/curl -L 'https://script.google.com/macros/s/AKfycbznhjokzPBqMEIvIhfnA0UamYVSs_3F98dEo14zrpmxqhA4C4Adb3cJggRUC1xc2JcCAw/exec?hostname=$hostname'
    '';
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };

  users.users.nixos.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC5o7LT5wPYWgI8Mvr6RKOv+BcsbQgU7PCw2hheVu17alwF1uFUsAYV5BVQu+uv9uEm/UDsCNhfM6TwI0A1prdmtBz4pKiwXbj7fcdp6DcVOgTsPfawbXEpivtJvlhEatyTsR26MjHKnqpT0BxPvj6Ug6pvRkCYW5d2bWXiY9murmAX6Q5kSyNunkB8PdRTH+S47f7eOdCJY63VBOkkiG8M7XyPwFCDTYiHhbMZcejIdY9mB6kYnMQVRHDznQWiQxrcaE1fD/TY3db9GDcOVoo2aDBOZX7WT2+me67sU8dEK9+nSyhWDzBbEs8knu87ZlKPFwhl4slenRniKhbf22OpicXArtEcjEj0GyDJH5e+ZCIQ4eSQanA7TxnKFlDuaf+Qqx55UT+ya4vJJeik7nkzbRHaE9IoWhhiOaOnaN6kHIxuxB6z7EL3Gk7f78+I/qBaj5df6fgnXM3JBXKa5bRH2wqoSetJAo6EGpEgmU2huB1ktiGlO7BlF5XwSw6cb/KT7NSIXhncgLkCzsDVXxecVQv1FnPISBcp3+ti01ADVf2trgpPDbNTWV40Rgiefie0o2fc6KWAFfum1j5N3WWU+XVVmRjDmKKHiEJBLNKDAe0rQf+tryPW4c5GIN7aFoB+8dYFAuUyLd7Fu3vhZdmcckN5ryHunEc0dKPIiuoVZw=="
  ];

  system.stateVersion = "23.05";
}
