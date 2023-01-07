{ pkgs, ... }: {
# neovim-home-manager #



  home.stateVersion = "22.11";
  home.packages = [ pkgs.atool pkgs.httpie ];
# programs

  programs = { 
	  neovim = import ./neovim.nix pkgs;
	  zsh = import ./zsh.nix pkgs;
	  home-manager.enable = true;
  };

}


