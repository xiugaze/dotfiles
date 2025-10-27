-- configs at https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
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
    filetypes = { "rust" },
    cmd = {
      "rust-analyzer"
    },
    on_init = function(client, _)
      -- semantic token higlighting is weird with treesitter
      client.server_capabilities.semanticTokensProvider = nil 
    end,
    server_capabilities = {
      semanticTokensProvider = nil
    }
  },
  ["clangd-c"] = {
    filetypes = { "c", "h" },
    cmd = {
      "clangd",
      "--background-index",
      "--clang-tidy",
      "--log=verbose",
    },
  },
  -- ["clangd-sx"] = {
  --   filetypes = { "cpp", "c", "h" },
  --   cmd = {
  --     "clangd",
  --     "--query-driver",
  --     "/home/candreano/src/satcode/gidney/.toolchains/**/bin/*",
  --     "-j",
  --     "40",
  --   },
  -- }

  ["clangd-cpp"] = {
    filetypes = { "cpp", "cc", "hpp", "hh" },
    cmd = {
      "clangd",
      "--background-index",
      "--clang-tidy",
      "--log=verbose",
    },
    root_markers = { '.clangd', 'compile_commands.json' },
    init_options = {
      fallbackFlags = {
        "-std=c++20",
      }
    }
  },

  ["nil"] = {
    filetypes = { "nix", },
    cmd = { "nil" },
    -- this doesn't work
    formatting = {
      command = { "nixfmt" },
    },
  },

  -- jdtls = {},
  ["gopls"] = {
    cmd = {"gopls"},
    filetypes = { "go", "gomod", "gowork", "gotmpl" },
    -- NOTE: doesn't work
    -- on_init = function(client, args)
    --     if not client:supports_method('textDocument/willSaveUntil')
    --     and client:supports_method('textDocument/formatting') then
    --       vim.api.nvim_create_autocmd('BufWritePre', {
    --         group = vim.api.nvim_create_augroup('my.lsp', {clear=false}),
    --         buffer = args.buf,
    --         callback = function()
    --           vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
    --         end,
    --       })
    --     end
    -- end,
  },
  -- html = {},
  superhtml = {},
  ["basedpyright"] = {
    cmd = {"basedpyright-langserver", "--stdio"},
    filetypes = { "python" },
  },


  ["texlab"] = {
    cmd = {"texlab"},
    filetypes = {
      "tex", "bib",
    },


  },
  ["harper-ls"] = {
    cmd = {"harper-ls", "--stdio"},
    filetypes = {
      "c", "cpp", "cs", "gitcommit", "go", "html", "java", "javascript", "lua", "markdown", "nix", "python", "ruby", "rust", "swift", "toml", "typescript", "typescriptreact", "haskell", "cmake", "typst", "php", "dart", "clojure", "sh"
    },
    root_markers = { '.git' },
  },
  -- ruff = {},
}

for k, v in pairs(servers) do
  vim.lsp.config[k] = v
  vim.lsp.enable(k)
end
