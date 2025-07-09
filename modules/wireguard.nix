# For reference https://alberand.com/nixos-wireguard-vpn.html
{ pkgs, ... }: {
  networking.wg-quick.interfaces = let
    server_ip = "213.153.88.123";
  in {
    wg0 = {
      ips = [ "192.168.178.202/24" ];

      # To match firewall allowedUDPPorts (without this wg
      # uses random port numbers).
      listenPort = 51820;

      # Path to the private key file.
      privateKeyFile = "/etc/home-vpn.key";

      postUp = ''
        # Mark packets on the wg0 interface
        wg set wg0 fwmark 51820

        # Forbid anything else which doesn't go through wireguard VPN on
        # ipV4 and ipV6
        ${pkgs.iptables}/bin/iptables -A OUTPUT \
          ! -o wg0 \
          -m mark ! --mark $(wg show wg0 fwmark) \
          -m addrtype ! --dst-type LOCAL \
          -j REJECT
        ${pkgs.iptables}/bin/ip6tables -A OUTPUT \
          ! -o wg0 \
          -m mark ! --mark $(wg show wg0 fwmark) \
          -m addrtype ! --dst-type LOCAL \
          -j REJECT
      '';

      postDown = ''
        ${pkgs.iptables}/bin/iptables -D OUTPUT \
          ! -o wg0 \
          -m mark ! --mark $(wg show wg0 fwmark) \
          -m addrtype ! --dst-type LOCAL \
          -j REJECT
        ${pkgs.iptables}/bin/ip6tables -D OUTPUT \
          ! -o wg0 -m mark \
          ! --mark $(wg show wg0 fwmark) \
          -m addrtype ! --dst-type LOCAL \
          -j REJECT
      '';

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

