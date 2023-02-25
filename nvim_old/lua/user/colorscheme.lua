local colorscheme = "nord"

if colorscheme == "nord" then
    vim.g.nord_contrast = true
    vim.g.nord_borders = true
    vim.g.nord_disable_background = false
    vim.g.nord_italic = false
    vim.g.nord_uniform_diff_background = true
    vim.g.nord_bold = true

    -- Load the colorscheme
    require('nord').set()
end

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
  vim.notify("colorscheme " .. colorscheme .. " not found!")
  return
end

-- devicons
require'nvim-web-devicons'.setup {
 -- your personnal icons can go here (to override)
 -- you can specify color or cterm_color instead of specifying both of them
 -- DevIcon will be appended to `name`
 override = {
  zsh = {
    icon = "",
    color = "#428850",
    cterm_color = "65",
    name = "Zsh"
  }
 };
 -- globally enable different highlight colors per icon (default to true)
 -- if set to false all icons will have the default icon's color
 color_icons = true;
 -- globally enable default icons (default to false)
 -- will get overriden by `get_icons` option
 default = true;
}
