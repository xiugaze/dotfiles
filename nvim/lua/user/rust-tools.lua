local status_ok, rust_tools = pcall(require, "rust-tools")
if not status_ok then
    return
end

require("mason").setup()
require("mason-lspconfig").setup()


local rt = require("rust-tools")
local rust_opts = {
  server  = {
    on_attach = function(client, bufnr)
      -- Hover actions
      vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })

      -- Code action groups
      vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
        local bufopts = { noremap=true, silent=true, buffer=bufnr }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
        vim.keymap.set('n', 'gh', vim.lsp.buf.hover, bufopts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
        vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
        vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
        vim.keymap.set('n', '<space>wl', function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, bufopts)
        vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
        vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
        vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
        vim.keymap.set("n", "gk", vim.diagnostic.open_float, bufopts)
        vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)

    end,
    settings = {
      ['rust-analyzer'] = {
        checkOnSave = {
          command = "clippy",
            allTargets = false,
            extraArgs = {
                "--target",
                "thumbv7em-none-eabihf",
            }
        },

        allTargets = false,
        check = {
            allTargets = false,
        },
        target = "thumbv7em-none-eabihf",
      }
    }
  }
}

rt.setup(rust_opts)

-- local opts = {
--     tools = {
--         executor = require("rust-tools/executors").termopen, -- can be quickfix or termopen
--         reload_workspace_from_cargo_toml = true,
--         inlay_hints = {
--             auto = true,
--             only_current_line = false,
--             show_parameter_hints = true,
--             parameter_hints_prefix = "<-",
--             other_hints_prefix = "=>",
--             max_len_align = false,
--             max_len_align_padding = 1,
--             right_align = false,
--             right_align_padding = 7,
--             highlight = "Comment",
--         },
--         hover_actions = {
--             --border = {
--             --        { "╭", "FloatBorder" },
--             --        { "─", "FloatBorder" },
--             --        { "╮", "FloatBorder" },
--             --        { "│", "FloatBorder" },
--             --        { "╯", "FloatBorder" },
--             --        { "─", "FloatBorder" },
--             --        { "╰", "FloatBorder" },
--             --        { "│", "FloatBorder" },
--             --},
--             auto_focus = true,
--         },
--     },
--     server = {
--         --on_attach = require("user.lsp.init").common_on_attach,
--         --on_init = require("user.lsp.init").common_on_init,
--         settings = {
--             ["rust-analyzer"] = {
--                 checkOnSave = {
--                     command = "clippy"
--                 }
--             }
--         },
--     },
-- }
-- --local extension_path = vim.fn.expand "~/" .. ".vscode/extensions/vadimcn.vscode-lldb-1.7.3/"
--
-- --local codelldb_path = extension_path .. "adapter/codelldb"
-- --local liblldb_path = extension_path .. "lldb/lib/liblldb.dylib"
--
-- --opts.dap = {
-- --        adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
-- --}
-- rust_tools.setup(opts)
