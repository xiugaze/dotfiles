vim.keymap.set({"n"}, "<leader>ot", ":Obsidian today<CR>", {silent = true})
vim.keymap.set({"n"}, "<leader>oy", ":Obsidian yesterday<CR>", {silent = true})

vim.cmd("highlight Urgent ctermfg=red guifg=#f46c6c gui=bold")
vim.cmd("highlight Fixed ctermfg=green guifg=#9cc791 gui=bold")
vim.cmd("highlight Done ctermfg=blue guifg=#8bbebb gui=bold")
vim.cmd("highlight Bold term=bold cterm=bold gui=bold")

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


    vim.fn.matchadd("Bold", [[\<\%(Adam\|Aldrin\|Andrey\|Sandy\|Shreyas\)\>]])
    vim.fn.matchadd("Bold", [[\<>]])
    vim.w.urgent_match = vim.fn.matchadd("Urgent", [[\<URGENT\>]])
    vim.w.fixed_match = vim.fn.matchadd("Fixed", [[\<\%(FIXED\|MERGED\|DONE\)\>]])
    vim.w.fixed_match = vim.fn.matchadd("Done", [[\<\%(CLOSED\|IN PROGRESS\|IN REVIEW\)\>]])
  end,
})

vim.o.wrap = false
vim.o.linebreak = true
vim.o.conceallevel = 2
vim.o.spell = false
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.bo.shiftwidth = 2
vim.bo.expandtab = true
vim.o.tabstop = 2
vim.o.softtabstop = 2
