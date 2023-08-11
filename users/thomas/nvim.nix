{ pkgs, ... }:
{
  home.packages = with pkgs; [ fd ripgrep unzip wget zig ];

  programs.neovim = {
    enable = true;
    vimAlias = true;
    viAlias = true;
    vimdiffAlias = true;
    plugins = with pkgs.vimPlugins; [
      # Fuzzy Finder (files, lsp, etc)
      {
        plugin = telescope-nvim;
        type = "lua";
        config = ''
          local builtin = require("telescope.builtin")
          vim.keymap.set("n", "<leader>pf", builtin.find_files, {})
          vim.keymap.set("n", "<C-p>", builtin.git_files, {})
          vim.keymap.set("n", "<leader>ps", function()
            builtin.grep_string({ search = vim.fn.input("Grep > ") })
          end)
          vim.keymap.set("n", "<leader>vh", builtin.help_tags, {})
        '';
      }
      # dependency
      plenary-nvim
      # Fuzzy Finder Algorithm
      telescope-fzf-native-nvim

      # Color scheme
      {
        plugin = nightfox-nvim;
        type = "lua";
        config = ''
          require("nightfox").setup {
            options = {
              transparent = true,
            },
          }
          vim.cmd("colorscheme nordfox")
        '';
      }

      # Highlight, edit, and navigate code
      {
        plugin = nvim-treesitter.withPlugins (_: pkgs.tree-sitter.allGrammars );
        type = "lua";
        config = ''
          require("nvim-treesitter.configs").setup {
            sync_install = false,
            auto_install = false,

            autopairs = { enable = true, },
            highlight = {
              enable = true,
              -- TODO: periodically check if bash is working again
              disable = { "bash" },
              additional_vim_regex_highlighting = false,
            },
            indent = { enable = true, disable = { "yaml" } },
            context_commentstring = { enable = true, enable_autocmd = false, },
          }
        '';
      }
      nvim-treesitter-context
      nvim-treesitter-textobjects

      # Switch between files, blazingly fast ...
      {
        plugin = harpoon;
        type = "lua";
        config = ''
          local mark = require("harpoon.mark")
          local ui = require("harpoon.ui")

          vim.keymap.set("n", "<leader>a", mark.add_file)
          vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)

          vim.keymap.set("n", "<C-h>", function() ui.nav_file(1) end)
          vim.keymap.set("n", "<C-t>", function() ui.nav_file(2) end)
          vim.keymap.set("n", "<C-n>", function() ui.nav_file(3) end)
          vim.keymap.set("n", "<C-s>", function() ui.nav_file(4) end)
        '';
      }

      # See and undo recent changes
      {
        plugin = undotree;
        type = "lua";
        config = ''
          vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
        '';
      }

      # Git related plugins
      {
        plugin = vim-fugitive;
        type = "lua";
        config = ''
          vim.keymap.set("n", "<leader>gs", vim.cmd.Git)
        '';
      }

      # LSP Support
      nvim-lspconfig
      # Autocompletion
      nvim-cmp
      cmp-buffer
      cmp-path
      cmp_luasnip
      cmp-nvim-lsp
      cmp-nvim-lua
      # Snippets
      luasnip
      friendly-snippets

      {
        plugin = lsp-zero-nvim;
        type = "lua";
        config = ''
          local lsp = require("lsp-zero").preset({})

          lsp.on_attach(function(client, bufnr)
            local opts = {buffer = bufnr, remap = false}

            vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
            vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
            vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
            vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
            vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
            vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
            vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
            vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
            vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
            vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
          end)

          -- When you don't have mason.nvim installed
          -- You'll need to list the servers installed in your system
          lsp.setup_servers({"lua_ls", "nil_ls", "bashls", "rust_analyzer"})

          -- (Optional) Configure lua language server for neovim
          --require("lspconfig").lua_ls.setup(lsp.nvim_lua_ls())

          lsp.setup()

          vim.diagnostic.config({ virtual_text = true })
        '';
      }

      # Adds a terminal to nvim
      toggleterm-nvim
    ];
    extraLuaConfig = ''
      vim.g.mapleader = " "
      vim.g.maplocalleader = " "

      vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

      vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
      vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")

      vim.keymap.set("n", "J", "mzJ`z")
      vim.keymap.set("n", "<C-d>", "<C-d>zz")
      vim.keymap.set("n", "<C-u>", "<C-u>zz")
      vim.keymap.set("n", "n", "nzzzv")
      vim.keymap.set("n", "N", "Nzzzv")

      -- greatest remap ever
      vim.keymap.set("x", "<leader>p", [["_dP]])

      -- next greatest remap ever : asbjornHaland
      vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
      vim.keymap.set("n", "<leader>Y", [["+Y]])

      vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])

      -- This is going to get me cancelled
      vim.keymap.set("i", "<C-c>", "<Esc>")

      vim.keymap.set("n", "Q", "<nop>")
      vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
      vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

      vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
      vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
      vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
      vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

      vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
      vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

      vim.keymap.set("n", "<leader><leader>", function()
        vim.cmd("so")
      end)

      vim.opt.guicursor = ""

      vim.opt.nu = true
      vim.opt.relativenumber = true

      vim.opt.tabstop = 4
      vim.opt.softtabstop = 4
      vim.opt.shiftwidth = 4
      vim.opt.expandtab = true

      vim.opt.smartindent = true

      vim.opt.wrap = false

      vim.opt.swapfile = false
      vim.opt.backup = false
      vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
      vim.opt.undofile = true

      vim.opt.hlsearch = false
      vim.opt.incsearch = true

      vim.opt.termguicolors = true

      vim.opt.scrolloff = 8
      vim.opt.signcolumn = "yes"
      vim.opt.isfname:append("@-@")

      vim.opt.updatetime = 50

      vim.opt.colorcolumn = "80"
    '';
   };
}

