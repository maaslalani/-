{pkgs, ...}: {
  config.programs.neovim = {
    enable = true;
    extraLuaConfig = builtins.readFile "${pkgs.fnl}/init.lua";
    extraConfig = ''
      imap <silent><script><expr> <C-J> copilot#Accept("\<CR>")
      ${(import ./colorscheme.nix) pkgs.lib}
    '';
    vimAlias = true;
    viAlias = true;
    plugins = with pkgs.vimPlugins; [
      cmp-buffer
      cmp-nvim-lsp
      cmp-path
      colorbuddy-nvim
      copilot-vim
      friendly-snippets
      gitsigns-nvim
      hop-nvim
      luasnip
      null-ls-nvim
      nvim-autopairs
      nvim-cmp
      nvim-lspconfig
      nvim-treesitter
      plenary-nvim
      popup-nvim
      telescope-nvim
      tokyonight-nvim
      vim-commentary
      vim-fugitive
      vim-hexokinase
      vim-rhubarb
      vim-sleuth
      vim-surround
      vim-test
      which-key-nvim
    ];
  };
}
