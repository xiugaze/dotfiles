local servers = {
  ["lua-language-server"] = {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    settings = {
      Lua = {
        completion = {
          callSnippet = 'Replace',
        },
      }
    },
  },

  ["rust-analyzer"] = {
    filetyles = { "rs" },
    cmd = {
      "rust-analyzer"
    },
  },
  ["clangd"] = {
    filetypes = { "c", "cpp" },
    cmd = {
      "clangd",
      "--background-index",
      "--clang-tidy",
      "--log=verbose",
      -- "-std=c++20",
    },
    -- init_options = {
    --     fallbackFlags = {
    --     }
    -- }
  },

  ["nil"] = {
    filetypes = { "nix", },
    cmd = { "nil" },
    formatting = {
      command = { "nixfmt" },
    },
  },

  jdtls = {},
  gopls = {},
  html = {},
  superhtml = {},
  basedpyright = {},
  ruff = {},
}

for k, v in pairs(servers) do
  vim.lsp.config[k] = v
  vim.lsp.enable(k)
end
