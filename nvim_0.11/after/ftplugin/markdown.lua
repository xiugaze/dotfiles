vim.keymap.set({"n"}, "<leader>ot", ":Obsidian today<CR>", {silent = true})
vim.keymap.set({"n"}, "<leader>oy", ":Obsidian yesterday<CR>", {silent = true})

vim.cmd("highlight Urgent ctermfg=red guifg=#ff0000 gui=bold")
vim.cmd("highlight Fixed ctermfg=green guifg=#77ec6f gui=bold")
vim.cmd("highlight Done ctermfg=blue guifg=#78bff4 gui=bold")
vim.cmd("highlight Team term=bold cterm=bold gui=bold")

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function(args)
    -- Clear any stale matches in this buffer (optional)
    if vim.fn.exists("w:urgent_match") == 1 then
      vim.fn.matchdelete(vim.w.urgent_match)
    end

    if vim.fn.exists("w:fixed_match") == 1 then
      vim.fn.matchdelete(vim.w.fixed_match)
    end


    vim.fn.matchadd("Team", [[\<\%(Adam\|Aldrin\|Andrey\|Sandy\|Shreyas\)\>]])

    vim.w.urgent_match = vim.fn.matchadd("Urgent", [[\<URGENT\>]])
    vim.w.fixed_match = vim.fn.matchadd("Fixed", [[\<FIXED\>]])
    vim.w.fixed_match = vim.fn.matchadd("Done", [[\<\%(DONE\|CLOSED\)\>]])
  end,
})

vim.o.wrap = true
vim.o.linebreak = true
vim.o.conceallevel = 2
vim.o.spell = false
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.softtabstop = 2
