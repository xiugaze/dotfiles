return {
    'lervag/vimtex',
    config = function()
        vim.g.vimtex_view_method = "zathura"
        vim.opt.conceallevel = 1
        vim.g.tex_conceal = "abdmgs"
        vim.g.vimtex_syntax_conceal = {
               accents =  1,
               ligatures = 1,
               cites = 1,
               fancy= 1,
               spacing= 1,
               greek= 1,
               math_bounds= 1,
               math_delimiters= 1,
               math_fracs= 1,
               math_super_sub= 1,
               math_symbols= 1,
               sections= 0,
               styles=1,
        }
        vim.g.tex_flavor='latex'
    end
}
