return {
  "obsidian-nvim/obsidian.nvim",
  version = "*", 
  lazy = true,
  ft = "markdown",
  dependencies = {
    -- Required.
    "nvim-lua/plenary.nvim",

    -- see above for full list of optional dependencies ☝️
  },
  ---@module 'obsidian'
  ---@type obsidian.config
  opts = {
    legacy_commands = false,
    workspaces = {
      {
        name = "notes",
        path = "~/docs/notes",
      },
    },
    completion = { blink = true },
    frontmatter = {enabled = false},
    daily_notes = {
        folder = "daily",
        date_format = "%Y-%m-%d",
        alias_format = "%B %-d, %Y",
        default_tags = { "daily-notes" },
        template = "daily.md",
    },
    templates = {
      folder = "templates",
      substitutions = {
        calendar = function()
          return vim.fn.system([[cal | sed -E "s/(^|[^0-9])]] .. os.date("%-d") .. [[([^0-9]|$)/\1**]] .. os.date("%-d") .. [[**\2/g"]])
        end,
        cal_week = function()
         local today = os.date("%-d")

          -- Build shell pipeline:
          -- 1. cal -w   -> adds “week” column on the left
          -- 2. sed      -> bolds the entire line that contains today’s day
          local cmd = string.format(
            [[cal -w | sed -E 's/.*(^|[^0-9])%s([^0-9]|$).*/**&**/']], today
          )
        end,
      }
    },
    ui = {
      -- hl_groups = {
      --   ObsidianTodo = { bold = true, fg = "#f78c6c" },
      --   ObsidianDone = { bold = true, fg = "#89ddff" },
      --   ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
      --   ObsidianTilde = { bold = true, fg = "#ff5370" },
      --   ObsidianImportant = { bold = true, fg = "#d73128" },
      --   ObsidianBullet = { bold = true, fg = "#89ddff" },
      --   ObsidianRefText = { underline = true, fg = "#c792ea" },
      --   ObsidianExtLinkIcon = { fg = "#c792ea" },
      --   ObsidianTag = { italic = true, fg = "#89ddff" },
      --   ObsidianBlockID = { italic = true, fg = "#89ddff" },
      --   ObsidianHighlightText = { bg = "#75662e" },
      -- },
    --   checkboxes = {
    --     [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
    --     ["x"] = { char = "", hl_group = "ObsidianDone" },
    --     -- [">"] = { char = "", hl_group = "ObsidianRightArrow" },
    --     -- ["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
    --     -- ["!"] = { char = "", hl_group = "ObsidianImportant" },
    --   }
    },
    checkbox = {
      enabled = true,
      order = { " ", "x" },
    },
  }
}
