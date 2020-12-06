local vim = vim
local lsp = require'nvim_lsp'
local completion = require'completion'
local treesitter = require'nvim-treesitter.configs'

vim.cmd("packadd completion-nvim")
vim.cmd("packadd nvim-lspconfig")

lsp.gopls.setup {
  on_attach = completion.on_attach,
  cmd = {"gopls", "serve"},
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
    },
  },
}

local servers = {
  'bashls',
  'dockerls',
  'omnisharp',
  'rnix',
  'solargraph',
  'sumneko_lua',
  'tsserver',
}

for _, server in pairs(servers) do
  lsp[server].setup { on_attach = completion.on_attach }
end


function Goimports()
  local context = { source = { organizeImports = true } }
  vim.validate { context = { context, "t", true } }
  local params = vim.lsp.util.make_range_params()
  params.context = context
  local resp = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 1000)
  if resp and resp[1] and resp[1].result and resp[1].result[1] and resp[1].result[1].edit then
    vim.lsp.util.apply_workspace_edit(resp[1].result[1].edit)
  end
  vim.lsp.buf.formatting()
end

treesitter.setup {
  ensure_installed = {"nix"},
  highlight = {
    enable = true,
  },
}
