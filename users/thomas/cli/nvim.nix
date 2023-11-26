{ inputs, config, pkgs, ... }:
{
  imports = [ inputs.nixvim.homeManagerModules.nixvim ];

  home.packages = with pkgs; [ ripgrep fd ];

  programs.nixvim = {
    enable = true;

    globals.mapleader = " ";

    options = {
      guicursor = "";

      number = true;
      relativenumber = true;

      tabstop = 4;
      softtabstop = 4;
      shiftwidth = 4;
      expandtab = true;

      smartindent = true;

      wrap = false;

      swapfile = false;
      backup = false;
      undodir = "${config.xdg.dataHome}/nvim/undodir";
      undofile = true;

      hlsearch = false;
      incsearch = true;

      termguicolors = true;

      scrolloff = 8;
      signcolumn = "yes";
      isfname = [ "@-@" ];

      updatetime = 50;

      colorcolumn = "80";
    };

    keymaps = [
      { key = "<leader>t"; action = ":NvimTreeToggle<CR>"; mode = "n"; }

      { key = "K"; action = ":m '<-2<CR>gv=gv"; mode = "v"; }
      { key = "J"; action = ":m '>+1<CR>gv=gv"; mode = "v"; }

      { key = "J"; action = "mzJ`z"; mode = "n"; }
      { key = "<C-d>"; action = "<C-d>zz"; mode = "n"; }
      { key = "<C-u>"; action = "<C-u>zz"; mode = "n"; }
      { key = "n"; action = "nzzzv"; mode = "n"; }
      { key = "N"; action = "Nzzzv"; mode = "n"; }

      { key = "<leader>p"; action = "[[\"_dP]]"; mode = "v"; }

      { key = "<leader>y"; action = "[[\"+y]]"; }
      { key = "<leader>Y"; action = "[[\"+Y]]"; mode = "n"; }
    ];

    # need to update this to keymaps at some point
    maps = {
      normalVisualOp."<leader>d" = "[[\"_d]]";

      insert."<C-c>" = "<Esc>";

      normal."Q" = "<nop>";
      normal."<C-f>" = "<cmd>silent !tmux neww tmux-sessionizer<CR>";

      normal."<C-k>" = "<cmd>cnext<CR>zz";
      normal."<C-j>" = "<cmd>cprev<CR>zz";
      normal."<leader>k" = "<cmd>lnext<CR>zz";
      normal."<leader>j" = "<cmd>lprev<CR>zz";

      normal."<leader>s" = "[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])";
      normal."<leader>x" = {
        action = "<cmd>!chmod +x %<CR>";
        silent = true;
      };

      normal."<leader>u" = ":UndotreeToggle<CR>";
      normal."<leader>gs" = ":Git<CR>";
      insert."<C-h>" = "<cmd>:lua vim.lsp.buf.signature_help()<CR>";
    };

    colorschemes.kanagawa = {
      enable = true;
      theme = "dragon";
      transparent = true;
    };

    plugins = {
      tmux-navigator.enable = true;

      telescope = {
        enable = true;
        extraOptions.pickers.find_files.follow = true;
        keymaps = {
          "<leader>e" = "find_files";
          "<C-p>" = "git_files";
          "<leader>ps" = "grep_string";
          "<leader>vh" = "help_tags";
        };
        extensions.fzf-native.enable = true;
      };

      treesitter = {
        enable = true;
        ensureInstalled = "all";
        indent = true;
        nixvimInjections = true;
      };
      treesitter-context.enable = true;

      nvim-tree = {
        enable = true;
        disableNetrw = true;
        extraOptions = {
          renderer = {
            root_folder_label = false;
            icons = {
              glyphs = {
                default = "";
                symlink = "";
                git = {
                  unstaged = "";
                  staged = "S";
                  unmerged = "";
                  renamed = "➜";
                  deleted = "";
                  untracked = "U";
                  ignored = "◌";
                };
                folder = {
                  default = "";
                  open = "";
                  empty = "";
                  empty_open = "";
                  symlink = "";
                };
              };
            };
          };
        };
      };

      harpoon = {
        enable = true;
        keymaps = {
          addFile = "<leader>a";
          toggleQuickMenu = "<C-e>";
          navFile = {
            "1" = "<C-h>";
            "2" = "<C-t>";
            "3" = "<C-n>";
            "4" = "<C-s>";
          };
        };
      };

      undotree = {
        enable = true;
        focusOnToggle = true;
      };

      fugitive.enable = true;
      comment-nvim.enable = true;

      lsp = {
        enable = true;
        onAttach = ''
          if client.server_capabilities.inlayHintProvider then
            vim.lsp.buf.inlay_hint(bufnr, true)
          end
        '';

        keymaps = {
          diagnostic = {
            "<leader>vd" = "open_float";
            "[d" = "goto_next";
            "]d" = "goto_prev";
          };
          lspBuf = {
            "<leader>f" = "format";
            "gd" = "definition";
            "K" = "hover";
            "<leader>vws" = "workspace_symbol";
            "<leader>vca" = "code_action";
            "<leader>vrr" = "references";
            "<leader>vrn" = "rename";
          };
        };

        servers.bashls.enable = true;
        servers.denols = {
          enable = true;
          rootDir = ''
            require('lspconfig').util.root_pattern("deno.json", "deno.jsonc")
          '';
        };
        servers.elixirls.enable = true;
        servers.nil_ls.enable = true;
        servers.rust-analyzer.enable = true;
        servers.tailwindcss.enable = true;
        servers.tsserver = {
          enable = true;
          autostart = false;
        };
        servers.volar.enable = true;
      };

      fidget.enable = true;
      nvim-cmp.enable = true;
      cmp-buffer.enable = true;
      cmp-path.enable = true;
      cmp_luasnip.enable = true;
      cmp-nvim-lsp.enable = true;
      cmp-nvim-lua.enable = true;
      luasnip.enable = true;
    };
  };
}
