return {
    "nvim-neo-tree/neo-tree.nvim",
    lazy = false,
    branch = "v2.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },
    config = function()
        vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])
        require("neo-tree").setup({
            hijack_netrw_behavior = "open_default",
            close_if_last_window = true,
            popup_border_style = "rounded",
            window = {
                position = "float",
                width = "40",
                mappings = {
                    ["l"] = {
                        "toggle_node",
                        nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use
                    },
                    ["o"] = "open",
                },
                popup = {
                                -- settings that apply to float position only
                    size = { height = "17", width = "45" },
                    position = "50%", -- 50% means center it
                },
            },
        })
    end
}
