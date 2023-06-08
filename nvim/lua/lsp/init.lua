
local on_attach = function(_, bufnr)
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')


  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('gh', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
  nmap('<leader>gfo', ':Format<CR>', '[G]et [Fo]rmat')

end


-- Setup neovim lua configuration
require('neodev').setup()

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)


-- local rust_analyzer, rust_analyzer_cmd = nil, { "rustup", "run", "nightly", "rust-analyzer" }
-- local has_rt, rt = pcall(require, "rust-tools")
-- if has_rt then
--   local extension_path = vim.fn.expand "~/.vscode/extensions/sadge-vscode/extension/"
--   local codelldb_path = extension_path .. "adapter/codelldb"
--   local liblldb_path = extension_path .. "lldb/lib/liblldb.so"
--   
--   local rt_binds = function(_, bufnr)
--       vim.keymap.set("n", "<Leader>k", rt.hover_actions.hover_actions, { buffer = bufnr })
--       vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
--   end
--
--   rt.setup {
--     server = {
--       cmd = rust_analyzer_cmd,
--       capabilities = capabilities,
--       on_attach = function(_, bufnr)
--         rt_binds(_, bufnr)
--         on_attach(_, bufnr)
--       end;
--     },
--     dap = {
--       adapter = nil
--     },
--     tools = {
--       inlay_hints = {
--         auto = false,
--       },
--       hover_actions = {
--         auto_focus = true,
--       },
--     },
--   }
-- else
--   rust_analyzer = {
--     cmd = rust_analyzer_cmd,
--     settings = {
--       ["rust-analyzer"] = {
--         checkOnSave = {
--           command = "clippy",
--         },
--       },
--     },
--   }
-- end
--
-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
local servers = {
  -- clangd = {},
  -- gopls = {},
  -- pyright = {},
  -- rust_analyzer = {},
  -- tsserver = {},
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
  -- rust_analyzer = rust_analyzer,
  clangd = {},
  pyright = {},
  html = {},
  cssls = {},
  jdtls = {},
}

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers

-- Setup mason so it can manage external tooling

local settings = {
   ui = {
    border = "rounded",
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    }
  },
}

require('lspconfig.ui.windows').default_options.border = "rounded"
require('mason').setup(settings)
-- Ensure the servers above are installed
require('mason-lspconfig').setup {
  ensure_installed = vim.tbl_keys(servers),
  automatic_installation = true,
}
require('lspconfig').ghdl_ls.setup{}
---
local setup_server = function(server, config)
  if not config then
    return
  end

  if type(config) ~= "table" then
    config = {}
  end

  config = vim.tbl_deep_extend("force", {
    on_attach = on_attach,
    capabilities = capabilities,
    flags = {
      debounce_text_changes = nil,
    },
  }, config)

  require('lspconfig')[server].setup(config)
end

for server, config in pairs(servers) do
  setup_server(server, config)
end
