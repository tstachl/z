{ pkgs, lib, ... }:
{
  home.packages = [ pkgs.ripgrep pkgs.zig ];

  programs.neovim = {
    enable = true;
    vimAlias = true;
    viAlias = true;
    vimdiffAlias = true;
    plugins = with pkgs.vimPlugins; [
      (
        nvim-treesitter.withPlugins (_: pkgs.tree-sitter.allGrammars )
      )
      popup-nvim
      plenary-nvim
      telescope-nvim
      toggleterm-nvim
      nightfox-nvim
      lualine-nvim
      bufferline-nvim
      vim-bbye
      nvim-tree-lua
      gitsigns-nvim
      nvim-cmp
      nvim-autopairs
      which-key-nvim
      editorconfig-nvim

      nvim-lspconfig
      rust-tools-nvim
    ];
    extraLuaConfig = ''
      vim.cmd("set secure exrc")

      ${lib.strings.fileContents ./options.lua}
      ${lib.strings.fileContents ./keymaps.lua}

      -- colorscheme --
      require"nightfox".setup {
        options = {
          transparent = true,
        },
      }
      vim.cmd("colorscheme nordfox")

      ${lib.strings.fileContents ./plugins/autopairs.lua}
      ${lib.strings.fileContents ./plugins/bufferline.lua}
      ${lib.strings.fileContents ./plugins/cmp.lua}
      ${lib.strings.fileContents ./plugins/lualine.lua}
      ${lib.strings.fileContents ./plugins/nvim-tree.lua}
      ${lib.strings.fileContents ./plugins/telescope.lua}
      ${lib.strings.fileContents ./plugins/toggleterm.lua}
      ${lib.strings.fileContents ./plugins/treesitter.lua}
      ${lib.strings.fileContents ./plugins/whichkey.lua}

      ${lib.strings.fileContents ./plugins/lspconfig.lua}
      ${lib.strings.fileContents ./plugins/rust-tools.lua}
    '';
   };
}

