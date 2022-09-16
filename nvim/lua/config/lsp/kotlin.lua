local lsp_config = require 'lspconfig'
local on_attach = require 'config/lsp/on_attach'

lsp_config.kotlin_language_server.setup({
  on_attach = function(client)
    client.server_capabilities.document_formatting = false
    on_attach(client)
  end
})
