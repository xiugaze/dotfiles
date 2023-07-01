return {
    "ggandor/leap.nvim",
    dependencies = {
        "tpope/vim-repeat"
    },
    config = function()
        require('leap').add_default_mappings()
        require('leap').setup({
            highlight_unlabeled_phase_one_targets = true,
        })
    end

}
