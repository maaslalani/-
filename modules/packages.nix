{ config, pkgs, lib, ... }:
let
  core = with pkgs; [
    entr
    exa
    fd
    git
    gnupg
    jq
    ripgrep
    sd
    sops
  ] ++ (import ./lsp.nix { pkgs = pkgs; });

  darwin = with pkgs; [
    cachix
    coreutils
    delve
    fennel
    ffmpeg
    fnlfmt
    git
    google-cloud-sdk
    graph-easy
    graphviz
    hammerspoon
    htop
    kubectl
    noti
    openssl
    pinentry_mac
    proselint
    rubyPackages_3_0.rails
    ruby_3_0
    rustup
    sc-im
    sops
    spotify-tui
    spotifyd
    terraform
  ];

  linux = [ ];
in
{
  home.packages = core ++
    (if pkgs.stdenv.isDarwin then darwin else linux);

  programs.bat.config.theme = "Nord";
  programs.bat.enable = true;
  programs.home-manager.enable = true;
  programs.taskwarrior.colorTheme = "dark-16";
  programs.taskwarrior.enable = true;
  programs.z-lua.enable = true;
}
