{config, pkgs, pkgs-unstable,  ... }: {

    home.packages = with pkgs; [ 
        vscode
        gh
        python3
        flameshot
    ];

    programs.git = {
      enable = true;
      userEmail = "jandavid555@gmail.com";
      userName = "JD-GG";
      extraConfig = {
        push.autoSetupRemote = true;
      };
    };


    home.username = "jd";
    home.homeDirectory = "/home/jd";
    home.shellAliases = {
      dev = "cd /home/jd/Documents/GitHub";
      switch = "sudo nixos-rebuild switch --flake /home/jd/dotfiles#";
    };

    programs.home-manager.enable = true;

    programs.bash.enable = true;
    home.stateVersion = "24.05";
}
