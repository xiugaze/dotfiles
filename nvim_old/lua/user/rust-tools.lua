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
        local opts = { noremap = true, silent = true }
        vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
        -- changed from K
        vim.api.nvim_buf_set_keymap(bufnr, "n", "gh", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
        -- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "gqf", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "gk", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "[d", '<cmd>lua vim.diagnostic.goto_prev({ border = "rounded" })<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "gfo", "<cmd>lua vim.lsp.buf.format({async = true})<CR>", opts);
        vim.api.nvim_buf_set_keymap(
            bufnr,
            "n",
            "gl",
            '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics({ border = "rounded" })<CR>',
            opts
        )
        vim.api.nvim_buf_set_keymap(bufnr, "n", "]d", '<cmd>lua vim.diagnostic.goto_next({ border = "rounded" })<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
        vim.cmd [[ command! Format execute 'lua vim.lsp.buf.formatting()' ]]

    end,
    settings = {
      ['rust-analyzer'] = {
        checkOnSave = {
          command = "clippy",
        },

        allTargets = false,
        check = {
            allTargets = false,
        },
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
