require("dapui").setup()

local dap, dapui = require("dap"), require("dapui")


-- close and open UI automatically
dap.listeners.after.event_initialized["dapui_config"] = function ()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function ()
  dapui.close()
end
dap.listeners.after.event_exited["dapui_config"] = function ()
  dapui.close()
end

vim.keymap.set("n", "<Leader>bp", ":DapToggleBreakpoint<CR>")
vim.keymap.set("n", "<Leader>dx", ":DapTerminate<CR>")
vim.keymap.set("n", "<Leader>ds", ":DapStepOver<CR>")
