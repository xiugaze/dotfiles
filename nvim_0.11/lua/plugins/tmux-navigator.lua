return {
  "christoomey/vim-tmux-navigator",
  cmd = {
    "TmuxNavigateLeft",
    "TmuxNavigateDown",
    "TmuxNavigateUp",
    "TmuxNavigateRight",
    "TmuxNavigatePrevious",
  },
  keys = {
    { "<c-h>",  "<silent> <cmd><C-U>TmuxNavigateLeft<cr>" },
    { "<c-j>",  "<silent> <cmd><C-U>TmuxNavigateDown<cr>" },
    { "<c-k>",  "<silent> <cmd><C-U>TmuxNavigateUp<cr>" },
    { "<c-l>",  "<silent> <cmd><C-U>TmuxNavigateRight<cr>" },
    { "<c-\\>", "<silent> <cmd><C-U>TmuxNavigatePrevious<cr>" },
  },
}
