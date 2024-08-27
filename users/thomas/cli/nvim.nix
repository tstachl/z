{ inputs, pkgs, ... }:
{
  home.packages = [
    pkgs.prettierd
    pkgs.eslint_d
    inputs.nixvim.packages.${pkgs.system}.editor
  ];

  #   extraPlugins = with pkgs.vimPlugins; [ wrapping-nvim ];
  #   extraConfigLua = ''
  #     require("wrapping").setup({
  #       auto_set_mode_filetype_allowlist = {
  #         "asciidoc",
  #         "gitcommit",
  #         "latex",
  #         "mail",
  #         "markdown",
  #         "rst",
  #         "tex",
  #         "text",
  #       },
  #       softener = { markdown = true },
  #     })
  #   '';
  # };
}
