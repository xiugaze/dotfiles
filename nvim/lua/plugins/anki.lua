return {
    "rareitems/anki.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    config = function()
        require("anki").setup({
            models = {
                Basic = "Koine"
            }
        })
    end,
}
