{ pkgs, lib, ... }:
{
  programs.neovim = {
    enable = true;
    vimAlias = true;
    viAlias = true;
    vimdiffAlias = true;
    plugins = with pkgs.vimPlugins; [
      (
        nvim-treesitter.withPlugins (
          plugins: with pkgs.tree-sitter-grammars; [
            tree-sitter-bash
            tree-sitter-comment
            tree-sitter-css
            tree-sitter-dart
            tree-sitter-dockerfile
            tree-sitter-go
            tree-sitter-graphql
            tree-sitter-html
            tree-sitter-javascript
            tree-sitter-json
            tree-sitter-json5
            tree-sitter-lua
            tree-sitter-markdown
            tree-sitter-nix
            tree-sitter-python
            tree-sitter-regex
            tree-sitter-ruby
            tree-sitter-rust
            tree-sitter-scss
            tree-sitter-toml
            tree-sitter-tsx
            tree-sitter-typescript
            tree-sitter-vim
            tree-sitter-vue
            tree-sitter-yaml
          ]
        )
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
    ];
    extraConfig = ''
      lua <<EOF
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
      EOF
    '';
   };
}

# { config, pkgs, lib, vimUtils, ... }:
# let
#   # installs a vim plugin from git with a given tag / branch
#   pluginGit = ref: repo: vimUtils.buildVimPluginFrom2Nix {
#     pname = "${lib.strings.sanitizeDerivationName repo}";
#     version = ref;
#     src = builtins.fetchGit {
#       url = "https://github.com/${repo}.git";
#       ref = ref;
#     };
#   };
#   # always installs latest version
#   plugin = pluginGit "HEAD";
#   nvim = pkgs.fetchFromGitHub {
#     owner = "tstachl";
#     repo = "nvim";
#     rev = "0dcb5c52d22c7b83793ff2ea608df6b1c3b9aa4a";
#     # need to run this in the terminal
#     # `nix-prefetch-url --unpack https://github.com/tstachl/nvim/archive/0dcb5c52d22c7b83793ff2ea608df6b1c3b9aa4a.tar.gz`
#     sha256 = "0cpv8i2ln18ff9x5j7jzwc48xiaijvxdy6688h5xga5mr1kjbwrh";
#   };
# in
# {
#   programs.neovim = {
#     enable = true;

#     # read in the vim config from filesystem
#     # this enables syntaxhighlighting when editing those
#     extraConfig = builtins.concatStringsSep "\n" [
#       (lib.strings.fileContents ./base.vim)
#       (lib.strings.fileContents ./plugins.vim)
#       (lib.strings.fileContents ./lsp.vim)

#       # this allows you to add lua config files
#       ''
#         lua << EOF

#         require "core.disable"
#         require "core.options"
#         require "core.keymaps"
#         require "core.plugins"

#         ${lib.strings.fileContents ./config.lua}
#         ${lib.strings.fileContents ./lsp.lua}
#         EOF
#       ''
#     ];

#     # install needed binaries here
#     extraPackages = with pkgs; [
#       # used to compile tree-sitter grammar
#       tree-sitter

#       # installs different langauge servers for neovim-lsp
#       # have a look on the link below to figure out the ones for your languages
#       # https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md
#       nodePackages.typescript nodePackages.typescript-language-server
#       gopls
#       nodePackages.pyright
#       rust-analyzer
#     ];
#     plugins = with pkgs.vimPlugins; [
#       # you can use plugins from the pkgs
#       vim-which-key

#       # or you can use our function to directly fetch plugins from git
#       (plugin "neovim/nvim-lspconfig")
#       (plugin "hrsh7th/nvim-compe") # completion
#       (plugin "Raimondi/delimitMate") # auto bracket

#       # this installs the plugin from 'lua' branch
#       (pluginGit "lua" "lukas-reineke/indent-blankline.nvim")

#       # syntax highlighting
#       (plugin "nvim-treesitter/nvim-treesitter")
#       (plugin "p00f/nvim-ts-rainbow") # bracket highlighting
#     ];
#   };

#   xdg.configFile.nvim.source = pkgs.fetchFromGitHub {
#     owner = "tstachl";
#     repo = "nvim";
#     rev = "0dcb5c52d22c7b83793ff2ea608df6b1c3b9aa4a";
#     # need to run this in the terminal
#     # `nix-prefetch-url --unpack https://github.com/tstachl/nvim/archive/0dcb5c52d22c7b83793ff2ea608df6b1c3b9aa4a.tar.gz`
#     sha256 = "0cpv8i2ln18ff9x5j7jzwc48xiaijvxdy6688h5xga5mr1kjbwrh";
#   };
# }
