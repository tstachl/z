{ inputs, config, ... }:
{
  imports = [ inputs.nixvim.homeManagerModules.nixvim ];

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

    maps = {
      normal."<leader>pv" = ":Ex<CR>";

      visual."K" = ":m '<-2<CR>gv=gv";
      visual."J" = ":m '>+1<CR>gv=gv";

      normal."J" = "mzJ`z";
      normal."<C-d>" = "<C-d>zz";
      normal."<C-u>" = "<C-u>zz";
      normal."n" = "nzzzv";
      normal."N" = "Nzzzv";

      # greatest remap ever
      visualOnly."<leader>p" = "[[\"_dP]]";

      # next greatest remap ever : asbjornHaland
      normalVisualOp."<leader>y" = "[[\"+y]]";
      normal."<leader>Y" = "[[\"+Y]]";

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
      insert."<C-h>" = "vim.lsp.buf.signature_help";
    };

    colorschemes.kanagawa = {
      enable = true;
      theme = "dragon";
      transparent = true;
    };

    plugins = {
      telescope = {
        enable = true;
        keymaps = {
          "<leader>pf" = "find_files";
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
        servers.nil_ls.enable = true;
        servers.rust-analyzer.enable = true;
        servers.tailwindcss.enable = true;
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
