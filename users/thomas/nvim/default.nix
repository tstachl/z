{ pkgs, lib, ... }:
{
  home.packages = [ pkgs.ripgrep pkgs.zig pkgs.unzip pkgs.wget ];

  programs.neovim = {
    enable = true;
    vimAlias = true;
    viAlias = true;
    vimdiffAlias = true;
    plugins = with pkgs.vimPlugins; [
      # Git related plugins
      vim-fugitive
      vim-rhubarb

      # Detect tabstop and shiftwidth automatically
      vim-sleuth

      # LSP Configuration & Plugins
      nvim-lspconfig
      # Useful status updates for LSP
      fidget-nvim
      # Additional lua configuration, makes nvim stuff amazing!
      neodev-nvim

      # Autocompletion
      nvim-cmp
      # Snippet Engine & its associated nvim-cmp source
      luasnip
      cmp_luasnip
      # Adds LSP completion capabilities
      cmp-nvim-lsp
      # Adds a number of user-friendly snippets
      friendly-snippets

      # Useful plugin to show you pending keybinds.
      which-key-nvim

      # Adds git related signs to the gutter, as well as utilities for managing changes
      gitsigns-nvim

      # Adds a terminal to nvim
      toggleterm-nvim

      # theme inspired by atom
      # onedark-nvim
      nightfox-nvim

      # Set lualine as statusline
      lualine-nvim

      # Add indentation guides even on blank lines
      indent-blankline-nvim

      # "gc" to comment visual regions/lines
      comment-nvim

      # Fuzzy Finder (files, lsp, etc)
      telescope-nvim
      # dependency
      plenary-nvim
      # Fuzzy Finder Algorithm
      telescope-fzf-native-nvim

      # Highlight, edit, and navigate code
      (
        nvim-treesitter.withPlugins (_: pkgs.tree-sitter.allGrammars )
      )
      nvim-treesitter-textobjects

      # editorconfig plugin
      editorconfig-nvim

      # rust tools
      rust-tools-nvim

      # (
      #   nvim-treesitter.withPlugins (_: pkgs.tree-sitter.allGrammars )
      # )
      # popup-nvim
      # plenary-nvim
      # telescope-nvim
      # toggleterm-nvim
      # lualine-nvim
      # bufferline-nvim
      # vim-bbye
      # nvim-tree-lua
      # gitsigns-nvim
      # nvim-cmp
      # nvim-autopairs
      # which-key-nvim
      # editorconfig-nvim

      # nvim-lspconfig
      # rust-tools-nvim
    ];
    extraLuaConfig = ''
      vim.g.mapleader = " "
      vim.g.maplocalleader = " "

      ${lib.strings.fileContents ./options.lua}
    '';
      # ${lib.strings.fileContents ./keymaps.lua}


      # ${lib.strings.fileContents ./plugins/autopairs.lua}
      # ${lib.strings.fileContents ./plugins/bufferline.lua}
      # ${lib.strings.fileContents ./plugins/cmp.lua}
      # ${lib.strings.fileContents ./plugins/lualine.lua}
      # ${lib.strings.fileContents ./plugins/nvim-tree.lua}
      # ${lib.strings.fileContents ./plugins/telescope.lua}
      # ${lib.strings.fileContents ./plugins/toggleterm.lua}
      # ${lib.strings.fileContents ./plugins/treesitter.lua}
      # ${lib.strings.fileContents ./plugins/whichkey.lua}

      # ${lib.strings.fileContents ./plugins/lspconfig.lua}
      # ${lib.strings.fileContents ./plugins/rust-tools.lua}
   };
}

