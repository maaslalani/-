{ config, pkgs, lib, ... }:
{
  config.programs.neovim = {
    enable = true;
    package = pkgs.neovim-nightly;
    extraConfig = ''
      imap <silent><script><expr> <C-J> copilot#Accept("\<CR>")
      lua <<EOF
      ${builtins.readFile "${pkgs.fnl}/init.lua"}
      EOF
    '';
    vimAlias = true;
    viAlias = true;
    plugins = with pkgs; [
      copilot
      gitsigns-nvim
      hop-nvim
      nordic-nvim
      null-ls
      nvim-lspconfig
      nvim-treesitter
      plenary-nvim
      popup-nvim
      telescope-nvim
      vim-rhubarb
      vim-surround
      which-key-nvim
    ] ++ [
      cmp-buffer
      cmp-cmdline
      cmp-luasnip
      cmp-nvim-lsp
      cmp-path
      friendly-snippets
      luasnip
      nvim-cmp
    ];
  };
}
