# For reference https://alberand.com/nixos-wireguard-vpn.html
{ pkgs, ... }: {
  networking.wg-quick.interfaces = let
    server_ip = "213.153.88.123";
  in {
    wg0 = {
      address = [ "192.168.178.202/24" ];

      # To match firewall allowedUDPPorts (without this wg
      # uses random port numbers).
      listenPort = 51820;

      # Path to the private key file.
      privateKeyFile = "/etc/home-vpn.key";

      peers = [{
        publicKey = "sH/8gn34B1zrZsVhUT0cL4/gL3kldVVWC26ydS78fwQ=";
        presharedKey = "djG2MOxquwlzf+MpdsaXz6Dt6y1ZGpl9t/OuwKFjrBQ=";
        allowedIPs = [ "192.168.178.0/24, 0.0.0.0/0" ];
        endpoint = "${server_ip}:58952";
        persistentKeepalive = 25;
      }];
    };
  };
}

