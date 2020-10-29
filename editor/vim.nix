{ pkgs }:
with builtins; let
  config = f: a: concatStringsSep "\n" (attrValues (mapAttrs f a));
  configArray = f: a: concatStringsSep "\n" (map f a);

  autocmdConfig = config (n: v: ("autocmd ${n} ${v}"));
  lspConfig = configArray (v: "require'nvim_lsp'.${v}.setup{on_attach=on_attach}");
  mapConfig = p: config (n: v: ("${p}${n} ${v}"));
  packsConfig = configArray (v: "packadd ${v}");
  settingsConfig = config (n: v: ("set ${n}=${toString v}"));
  togglesConfig = config (n: v: ("set ${if v then "" else "no"}${n}"));
  variablesConfig = config (n: v: ("let ${n}=${toString v}"));

  colorscheme = "nord";

  toggles = {
    autoindent = true;
    autoread = true;
    autowrite = true;
    backup = false;
    compatible = false;
    cursorline = true;
    errorbells = false;
    expandtab = true;
    hidden = true;
    hlsearch = true;
    ignorecase = true;
    incsearch = true;
    lazyredraw = true;
    number = true;
    ruler = true;
    showcmd = true;
    showmode = false;
    smartcase = true;
    splitbelow = true;
    splitright = true;
    swapfile = false;
    timeout = false;
    ttimeout = true;
    ttyfast = true;
    undofile = true;
    visualbell = true;
    wb = false;
    wildmenu = true;
    wrap = false;
    writebackup = false;
  };

  settings = {
    backspace = "indent,eol,start";
    cmdheight = 1;
    completeopt = "menuone,noinsert,noselect";
    concealcursor = "\"\"";
    encoding = "utf-8";
    laststatus = 0;
    numberwidth = 1;
    printfont = "PragmataPro:h12";
    shiftwidth = 2;
    shortmess = "filnxtToOFc";
    signcolumn = "yes";
    softtabstop = 2;
    synmaxcol = 300;
    t_vb = "";
    tabstop = 2;
    timeoutlen = 50;
    undodir = "~/.config/nvim/.undo";
    updatetime = 300;
    wildmode = "longest:full,full";
  };

  leaderKey = "<Space>";
  navigationKey = "<C-a>";
  terminalEscapeKey = "<C-\\><C-n>";

  maps.normal = {
    "<BS>" = "<Plug>(dirvish_up)";
    Q = ":q<CR>";
    S = ":%s//g<Left><Left>";
  };

  maps.silent = {
    gd = "<cmd>lua vim.lsp.buf.declaration()<CR>";
    gD = "<cmd>lua vim.lsp.buf.definition()<CR>";
    gr = "<cmd>lua vim.lsp.buf.references()<CR>";
    gh = "<cmd>lua vim.lsp.buf.hover()<CR>";
  };

  maps.leader = {
    "" = "<Nop>";
    c = ":Commands<CR>";
    f = ":FZF<CR>";
    gb = ":Gblame<CR>";
    gd = ":Gdiff<CR>";
    o = ":silent !open <cWORD><CR>";
    p = "\"*p";
    q = ":q<CR>";
    r = ":Rg!<CR>";
    t = ":tabnew<CR>";
    n = ":NextDiagnosticCycle<CR>";
    N = ":PrevDiagnosticCycle<CR>";
    w = ":w<CR>";
    y = "\"*y";
    "/" = ":BLines!<CR>";
  };

  maps.visual = {
    S = ":s//g<Left><Left>";
    s = ":sort<CR>";
  };

  maps.insert = {
    "<expr> <Tab>" = "pumvisible() ? \"\\<C-n>\" : \"\\<Tab>\"";
    "<expr> <S-Tab>" = "pumvisible() ? \"\\<C-p>\" : \"\\<S-Tab>\"";
  };

  commands = {
    W = "w";
    Q = "q";
    Wc = "!wc %";
    Tf = "TestFile";
  };

  filetype = {
    plugin = "on";
    indent = "on";
  };

  variables = {
    completion_matching_strategy_list = "['exact', 'substring', 'fuzzy']";
    diagnostic_auto_popup_while_jump = 1;
    diagnostic_enable_underline = 1;
    diagnostic_enable_virtual_text = 1;
    diagnostic_insert_delay = 0;
    loaded_netrw = 0;
    vimwiki_list = "[{'path': '~/wiki/', 'syntax': 'markdown', 'ext': '.wiki'}]";
  };

  autocmd = {
    CmdLineEnter = ": set nosmartcase";
    CmdLineLeave = ": set smartcase";
    TermOpen = "* setlocal nonumber signcolumn=no";
    BufWritePre = "*.go lua goimports()";
  };

  languageServers = [
    "gopls"
    "rnix"
    "solargraph"
    "tsserver"
  ];

  packs = [
    "nvim-lspconfig"
    "completion-nvim"
    "diagnostic-nvim"
  ];

in {
  enable = true;
  package = pkgs.neovim-nightly;
  extraConfig = ''
    colorscheme ${colorscheme}

    ${autocmdConfig autocmd}
    ${settingsConfig settings}
    ${togglesConfig toggles}
    ${variablesConfig variables}
    ${packsConfig packs}

    ${mapConfig ":command " commands}
    ${mapConfig "filetype " filetype}
    ${mapConfig "map <silent> ${leaderKey}" maps.leader}
    ${mapConfig "nmap " maps.normal}
    ${mapConfig "nnoremap <silent> " maps.silent}
    ${mapConfig "vmap " maps.visual}
    ${mapConfig "imap " maps.insert}

    lua <<EOF
    ${readFile ./config.lua}
    ${lspConfig languageServers}
    EOF
  '';
  vimAlias = true;
  viAlias = true;
  plugins = with pkgs.vimPlugins; [
    auto-pairs
    commentary
    fugitive
    fzf-vim
    gitgutter
    nord-vim
    polyglot
    vim-dirvish
    vim-signature
    vimwiki
  ] ++ (with (import <nixpkgs-unstable>{}).vimPlugins; [
    completion-nvim
    diagnostic-nvim
    nvim-lspconfig
  ]);
}
