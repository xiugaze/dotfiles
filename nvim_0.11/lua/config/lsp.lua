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
  -- gopls = {},
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
  -- ruff = {},
}

for k, v in pairs(servers) do
  vim.lsp.config[k] = v
  vim.lsp.enable(k)
end
