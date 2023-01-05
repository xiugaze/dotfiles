require("obsidian").setup({
 dir = "~/docs/school-notes/",
  completion = {
    nvim_cmp = true, -- if using nvim-cmp, otherwise set to false
  },
  note_frontmatter_func = function(note)
  end
})

vim.keymap.set(
  "n",
  "gf",
  function()
    if require('obsidian').util.cursor_on_markdown_link() then
      return "<cmd>ObsidianFollowLink<CR>"
    else
      return "gf"
    end
  end,
  { noremap = false, expr = true}
)
