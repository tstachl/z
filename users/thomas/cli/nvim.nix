{ inputs, config, pkgs, ... }:
{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
  ];

  home.packages = with pkgs; [ ripgrep fd ];

  programs.nixvim = {
    enable = true;

    colorschemes.kanagawa = {
      enable = true;
      settings.theme = "dragon";
      settings.transparent = true;
    };

    globals.mapleader = " ";

    keymaps = [
      { key = "<leader>pv"; action = ":Explore<cr>"; mode = "n"; }

      { key = "K"; action = ":m '<-2<cr>gv=gv"; mode = "v"; }
      { key = "J"; action = ":m '>+1<cr>gv=gv"; mode = "v"; }

      { key = "J"; action = "mzJ`z"; mode = "n"; }
      { key = "<C-d>"; action = "<C-d>zz"; mode = "n"; }
      { key = "<C-u>"; action = "<C-u>zz"; mode = "n"; }
      { key = "n"; action = "nzzzv"; mode = "n"; }
      { key = "N"; action = "Nzzzv"; mode = "n"; }

      {
        key = "<C-h>";
        action.__raw = "vim.lsp.buf.signature_help";
        mode = "i";
      }

      { key = "<leader>ot"; action = ":ObsidianToday<cr>"; mode = "n"; }
      { key = "<leader>on"; action = ":ObsidianNew<cr>"; mode = "n"; }
      { key = "<leader>os"; action = ":ObsidianSearch<cr>"; mode = "n"; }
    ];

    opts = {
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

    plugins = {
      comment.enable = true;
      tmux-navigator.enable = true;
      fidget.enable = true;

      cmp = {
        enable = true;
        settings.mapping = {
          "<C-Space>" = "cmp.mapping.complete()";
          "<C-d>" = "cmp.mapping.scroll_docs(-4)";
          "<C-e>" = "cmp.mapping.close()";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          "<CR>" = "cmp.mapping.confirm({ select = true })";
          "<C-p>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
          "<C-n>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
        };
      };
      cmp-buffer.enable = true;
      cmp-path.enable = true;
      cmp_luasnip.enable = true;
      cmp-nvim-lsp.enable = true;
      cmp-nvim-lua.enable = true;

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

        servers = {
          bashls.enable = true;

          denols = {
            enable = true;
            rootDir = "require('lspconfig').util.root_pattern('deno.json')";
            extraOptions.init_options = {
              lint = true;
              unstable = true;
            };
          };

          elixirls.enable = true;
          nil-ls.enable = true;
          tailwindcss.enable = true;

          tsserver = {
            enable = true;
            extraOptions.single_file_support = false;
            rootDir = ''
              require('lspconfig').util.root_pattern("tsconfig.json")
              '';
          };

          volar = {
            enable = true;
            rootDir = ''
              require('lspconfig').util.root_pattern("vite.config.mts")
              '';
          };
        };
      };

      obsidian = {
        enable = true;
        settings = {
          daily_notes = {
            folder = "daily";
            date_format = "%Y-%m-%d";
            alias_format = "%B %-d, %Y";
            template = "daily.md";
          };

          new_notes_location = "notes_subdir";

          note_id_func = ''
            function(title)
              -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
              -- In this case a note with the title 'My new note' will be given an ID that looks
              -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
              local suffix = ""
              if title ~= nil then
                -- If title is given, transform it into valid file name.
                suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
              else
                -- If title is nil, just add 4 random uppercase letters to the suffix.
                for _ = 1, 4 do
                  suffix = suffix .. string.char(math.random(65, 90))
                end
              end
              return tostring(os.date('%Y%m%d%H%M')) .. "-" .. suffix
            end
          '';

          open_notes_in = "hsplit";

          templates = {
            folder = "templates";
            date_format = "%Y-%m-%d";
            time_format = "%H:%M";
            substitutions = {
              "date:YYYY-MM-DD".__raw = ''
                function()
                  return os.date("%Y-%m-%d", os.time())
                end
              '';

              "date:MMMM D, YYYY".__raw = ''
                function()
                  return os.date("%B %d, %Y", os.time()):gsub(" 0", " ")
                end
              '';

              yesterday.__raw = ''
                function()
                  return os.date("%Y-%m-%d", os.time() - 86400)
                end
              '';

              tomorrow.__raw = ''
                function()
                  return os.date("%Y-%m-%d", os.time() + 86400)
                end
              '';
            };
          };

          workspaces = [{
            name = "Notes";
            path = "/Users/thomas/Obsidian/Notes";
            overrides = {
              notes_subdir = "notes";
            };
          }];
        };
      };

      telescope = {
        enable = true;
        settings.pickers.find_files.follow = true;
        keymaps = {
          "<leader>e" = "find_files";
          "<C-p>" = "git_files";
          "<leader>gs" = "grep_string";
          "<leader>lg" = "live_grep";
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

      zen-mode = {
        enable = true;
        settings = {
          plugins.alacritty.enabled = true;
          plugins.tmux.enabled = true;
          window.width = 0.6;
        };
      };
    };

    extraPlugins = with pkgs.vimPlugins; [ wrapping-nvim ];
    extraConfigLua = ''
      require("wrapping").setup({
        auto_set_mode_filetype_allowlist = {
          "asciidoc",
          "gitcommit",
          "latex",
          "mail",
          "markdown",
          "rst",
          "tex",
          "text",
        },
        softener = { markdown = true },
      })
    '';
  };
}
