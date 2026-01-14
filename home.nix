{config, pkgs, pkgs-unstable, inputs, ... }: {

    home.packages = with pkgs; [ 
        vscode
        python3
        nerd-fonts.jetbrains-mono
        platformio
        github-desktop
        postman
        kicad
        discord
        inputs.openconnect-sso.packages.${pkgs.system}.openconnect-sso
        kitty
        arduino-ide
        direnv
    ];

    programs.git = {
      enable = true;
      userEmail = "jandavid555@gmail.com";
      userName = "JD-GG";
      extraConfig = {
        push.autoSetupRemote = true;
      };
    };

    programs.starship = {
      enable = true;
      settings = pkgs.lib.importTOML ./home/pastel-powerline.toml;
    };


    home.username = "jd";
    home.homeDirectory = "/home/jd";
    home.shellAliases = {
      dev = "cd /home/jd/Documents/GitHub";
      switch = "sudo nixos-rebuild switch --flake /home/jd/dotfiles#";
      dhbw-vpn = "openconnect-sso --server vpn.dhbw-heidenheim.de --authgroup Studenten+Externe-MFA";
      nd = "nix develop";
      nix-clean = "nix-collect-garbage -d";
    };

    programs.home-manager.enable = true;

    programs.bash.enable = true;
    home.stateVersion = "24.05";
}
