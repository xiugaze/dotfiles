return {
    "epwalsh/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = true,
    --  ft = "markdown",
    -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
    event = {
        -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
        -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
        "BufReadPre /home/caleb/docs/school-notes/**.md",
        "BufNewFile /home/caleb/docs/school-notes/**.md",
    },

    dependencies = {
        -- Required.
        "nvim-lua/plenary.nvim",
    },
    opts = {
        workspaces = {
            {
                name = "notes",
                path = "~/docs/school-notes",
            },
        },
        disable_frontmatter = true,

        -- see below for full list of options 👇
        templates = {
            subdir = "nvim-templates",
            date_format = "%Y-%m-%d",
            time_format = "%H:%M",
        }
    },
}
