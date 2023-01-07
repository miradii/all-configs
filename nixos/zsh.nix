{ config, pkgs, lib, ... }: 
with pkgs; {
		  enable = true;
		  enableCompletion = true;
		  enableSyntaxHighlighting = true;
		  historySubstringSearch.enable = true;
		  historySubstringSearch.searchDownKey = "j";
		  historySubstringSearch.searchUpKey = "k";

		  plugins = [

		  {
	# will source zsh-autosuggestions.plugin.zsh
			  name = "zsh-autosuggestions";
			  src = pkgs.fetchFromGitHub {
				  owner = "zsh-users";
				  repo = "zsh-autosuggestions";
				  rev = "v0.4.0";
				  sha256 = "0z6i9wjjklb4lvr7zjhbphibsyx51psv50gm07mbb0kj9058j6kc";
			  };
		  }
		  {
			  name = "zsh-nix-shell";
			  file = "nix-shell.plugin.zsh";
			  src = pkgs.fetchFromGitHub {
				  owner = "chisui";
				  repo = "zsh-nix-shell";
				  rev = "v0.5.0";
				  sha256 = "0za4aiwwrlawnia4f29msk822rj9bgcygw6a8a6iikiwzjjz0g91";
			  };
		  }
		  ];

		  shellAliases = {
			  ll = "ls -l";
			  update = "sudo nixos-rebuild switch";
			  nixconf = "sudo vi  /etc/nixos/configuration.nix";
		  };
		  history = {
			  size = 10000;
		  };
		  oh-my-zsh = {
			  enable = true;
			  plugins = [ "git" "thefuck" "web-search" "themes" "tmux" "copyfile" "dirhistory" "colored-man-pages" "emacs" "common-aliases" "colorize" "fastfile"  "history-substring-search" "zsh-interactive-cd"  "zsh-navigation-tools" ];
			  theme = "af-magic";
		  };
		  initExtra = ''
			  source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
			  source ~/configs/bash/bash_aliases.sh
			  source ~/configs/bash/paths.sh
			  '';
}

