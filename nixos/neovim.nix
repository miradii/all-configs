{ config, pkgs, lib, ... }:
with lib; {

  

  enable = true;

  plugins = with pkgs.vimPlugins; [

# Fast navigation
	  leap-nvim
		  vim-tmux-navigator     
# Completions
		  nvim-autopairs
		  cmp-nvim-lsp
		  cmp-buffer
		  cmp-path
		  cmp-cmdline
		  cmp-nvim-lsp-signature-help
		  nvim-cmp
		  lspkind-nvim
# Snippets
		  luasnip
		  cmp_luasnip



		  nvim-treesitter
		  nvim-treesitter-textobjects
# git relate plugins
		  vim-fugitive
		  vim-rhubarb
		  legendary-nvim
		  gitsigns-nvim
# markdown
		  goyo-vim
		  tabular
# ui
		  feline-nvim
		  nord-nvim
		  catppuccin-nvim
		  onedarkpro-nvim
		  tokyonight-nvim
		  indent-blankline-nvim
		  comment-nvim
		  nvim-notify

		  vim-sleuth
		  telescope-nvim
		  {
			  plugin = telescope-nvim;
			  config = ''
				  :luafile ~/configs/nvim/telescope.lua
				  '';
		  }
  plenary-nvim
	  telescope-nvim
	  vim-unimpaired
	  mason-nvim

# LSP
	  nvim-lspconfig
	  nvim-lsp-ts-utils
# Mostly for linting
	  null-ls-nvim
# LSP status window
	  fidget-nvim
# Code actions sign
	  nvim-lightbulb
# Highlight selected symbol
	  vim-illuminate
	  zen-mode-nvim
	  which-key-nvim
	  {
		  plugin = nvim-tree-lua;
		  config = ":luafile ~/configs/nvim/neotree.lua";
	  }

  ]		;

  extraPackages = with pkgs; [
	  tree-sitter
# Language Servers
# Bash
		  nodePackages.bash-language-server
# Dart
#dart
# Elixir
#beam.packages.erlang.elixir_ls
# Erlang
#beam.packages.erlang.erlang-ls
# Haskell
#stable.haskellPackages.haskell-language-server
# Java
#java-language-server
# Kotlin
#kotlin-language-server
# Lua
#		  lua_ls
# Nix
		  rnix-lsp
		  nixpkgs-fmt
		  statix
# Python
#pyright
# python-debug
		  black
# Typescript
nodePackages.typescript-language-server
# Web (ESLint, HTML, CSS, JSON)
nodePackages.vscode-langservers-extracted
nodePackages_latest.eslint_d
vimPlugins.vim-prettier
# Telescope tools
		  ripgrep
		  fd
		  ];



  extraConfig = ''
	  :luafile ~/configs/nvim/init.lua
	  '';


}

