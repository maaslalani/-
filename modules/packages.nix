{
  config,
  pkgs,
  lib,
  ...
}: let
  core = with pkgs;
    [
      entr
      exa
      fd
      git
      gnupg
      jq
      pastel
      ripgrep
      sd
    ]
    ++ (import ./lsp.nix {pkgs = pkgs;});

  darwin = with pkgs; [
    alejandra
    cachix
    coreutils
    delve
    fennel
    ffmpeg
    fzf
    git
    go_1_19
    golangci-lint
    golangci-lint-langserver
    gopls
    hammerspoon
    htop
    nodejs-16_x
    openssl
    pinentry_mac
    rustup
    sc-im
    spotify-tui
    spotifyd
    twurl
    yarn
  ];

  linux = [];

  charmbracelet = with pkgs; [
    charm
    glow
    melt
    skate
    soft-serve
    gum
  ];
in {
  home.packages =
    core
    ++ charmbracelet
    ++ (
      if pkgs.stdenv.isDarwin
      then darwin
      else linux
    );

  programs.bat.config.theme = "Nord";
  programs.bat.enable = true;
  programs.home-manager.enable = true;
  programs.taskwarrior.colorTheme = "dark-16";
  programs.taskwarrior.enable = true;
  programs.z-lua.enable = true;
}
