{config, pkgs, pkgs-unstable,  ... }: {

    home.packages = with pkgs; [ 
        vscode
        git
        gh
    ];



    home.username = "jd";
    home.homeDirectory = "/home/jd";
    home.shellAliases = {
      dev = "cd /home/jd/Documents/GitHub";
      switch = "sudo nixos-rebuild switch --flake /home/jd/dotfile#";
    };

    programs.home-manager.enable = true;

    programs.bash.enable = true;
    home.stateVersion = "24.05";


}
