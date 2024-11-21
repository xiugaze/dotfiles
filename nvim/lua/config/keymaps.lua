local M = {}


local maps = {
	any = {
		["<leader>y"] = '"+y',
		["<leader>p"] = '"+p',
		["<leader>sh"] = ":set list!<CR>",
		["<leader>t"] = "<C-6>",
		["q:"] = "<nop>",
		["H"] = "g^",
		["L"] = "g$",
	},
	normal_mode = {
		["E"] = "ge",
        ["<Esc>"]=  "<cmd>nohlsearch<CR>",
	},
	insert_mode = {
		["<C-BS>"] = "<C-W>",
		["<C-H>"] = "<C-W>",
	},
	visual_mode = {
		-- stay in indent
		["<"] = "<gv",
		[">"] = ">gv",
	},
}

local mode_adapters = {
	insert_mode = "i",
	normal_mode = "n",
	term_mode = "t",
	visual_mode = "v",
	visual_block_mode = "x",
	command_mode = "c",
	operator_pending_mode = "o",
	any = "",
}

function M.set_keymap(mode, input, output, desc)
	vim.keymap.set(mode, input, output, { noremap = true, silent = true, desc = desc})
end

-- load basic keybinds
function M.load_basics()
	for mode, mappings in pairs(maps) do
		mode = mode_adapters[mode] or mode -- mode = mode character
		for input, output in pairs(mappings) do -- for input/output pairing
			M.set_keymap(mode, input, output)
		end
	end
	-- Remap for dealing with word wrap
	vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
	vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
end

-- nmap with descriptions, desc is an optional argument
function M.nmap(input, output, desc)
	vim.keymap.set("n", input, output, { noremap = true, silent = true, desc = desc or "" })
end

function M.load_telescope()
	local builtin = require("telescope.builtin")
	local set = M.nmap
	set("<leader>ff", builtin.find_files, "[f]ind [f]iles")
	set("<leader>fw", builtin.grep_string, "[f]ind [w]ord")
	set("<leader>fg", builtin.live_grep, "[f]ind [g]rep")
	set("<leader>ff", builtin.find_files, "[f]ind [f]iles")
	set("<leader>fd", builtin.diagnostics, "[f]ind [d]iagnostics")
	-- set("<leader>fr", builtin.resume, "[f]ind [r]esume") -- don't understand this
	set("<leader>f.", builtin.oldfiles, "[f]ind recent files")
	set("<leader>fs", builtin.builtin, "[f]ind [s]elect")
	set("<leader>fk", builtin.keymaps, "[f]ind [k]eymaps")
	vim.keymap.set('n', '<leader>sn', function()
		builtin.find_files { cwd = vim.fn.stdpath 'config' }
	end, { desc = '[S]earch [N]eovim files' })

    --   -- Slightly advanced example of overriding default behavior and theme
    --   vim.keymap.set('n', '<leader>/', function()
    --     -- You can pass additional configuration to Telescope to change the theme, layout, etc.
    --     builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    --       winblend = 10,
    --       previewer = false,
    --     })
    --   end, { desc = '[/] Fuzzily search in current buffer' })

    --   -- It's also possible to pass additional configuration options.
    --   --  See `:help telescope.builtin.live_grep()` for information about particular keys
    --   vim.keymap.set('n', '<leader>s/', function()
    --     builtin.live_grep {
    --       grep_open_files = true,
    --       prompt_title = 'Live Grep in Open Files',
    --     }
    --   end, { desc = '[S]earch [/] in Open Files' })

    --   -- Shortcut for searching your Neovim configuration files
    --   vim.keymap.set('n', '<leader>sn', function()
    --     builtin.find_files { cwd = vim.fn.stdpath 'config' }
    --   end, { desc = '[S]earch [N]eovim files' })
    -- end,
end

-- function M.load_plugins()
-- 	local map = M.nmap
-- 	map("<C-f>", ":lua vim.lsp.buf.format()<CR>", "Format")
-- 	map("<leader>e", "<cmd>Neotree toggle float<cr>", "Explorer (Neotree)")
-- 	map("<C-h>", "<cmd>NvimTmuxNavigateLeft<cr>", "Tmux Left")
-- 	map("<C-j>", "<cmd>NvimTmuxNavigateDown<cr>", "Tmux Down")
-- 	map("<C-k>", "<cmd>NvimTmuxNavigateUp<cr>", "Tmux Up")
-- 	map("<leader>ll", "<cmd>VimtexCompile<cr>", "Compile Tex Document")
-- 	map("<C-l>", "<cmd>NvimTmuxNavigateRight<cr>", "Tmux Right")

-- 	-- See `:help telescope.builtin`
-- 	local builtin = require("telescope.builtin")
-- 	map("<leader>?", builtin.oldfiles, "[?] Find recently opened files")
-- 	map("<leader><space>", builtin.buffers, "[ ] Find existing buffers")
-- 	map("<leader>fb", function()
-- 		builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
-- 			winblend = 10,
-- 			previewer = false,
-- 		}))
-- 	end, "[/] Fuzzily search in current buffer")

-- 	map("<leader>fgf", builtin.git_files, "[F]ind [G]it [F]iles")
-- 	map("<leader>fgs", builtin.git_status, "[F]ind [G]it [S]tatus")
-- 	map("<leader>ff", builtin.find_files, "[F]ind [F]iles")
-- 	map("<leader>fh", builtin.help_tags, "[F]ind [H]elp")
-- 	map("<leader>fs", builtin.live_grep, "[F]ind by [S]tring (with grep)")
-- 	map("<leader>fD", builtin.diagnostics, "[F]ind Workspace [D]iagnostics")
-- 	map("<leader>fi", builtin.lsp_implementations, "[F]ind [I]mplementation")
-- 	map("<leader>fd", function()
-- 		local opts = { bufnr = 0 }
-- 		require("telescope.builtin").diagnostics(opts)
-- 	end, "[F]ind [D]iagnostics")
-- 	map("<leader>fm", ":Telescope noice<CR>", "[F]ind [M]essages")
-- 	map("<leader>fa", ":Telescope aerial<CR>", "[F]ind [M]essages")
-- 	map("<leader>ft", ":TodoTelescope<CR>", "[F]ind [T]odo")
-- 	-- zenmode
-- 	map("<leader>z", ":ZenMode<CR>", "[Z]enmode")
-- end

-- For LSP-lines
-- M.toggle_lines = function()
-- 	local current = vim.diagnostic.config().virtual_lines
-- 	local new_value
-- 	if current == false then
-- 		new_value = { only_current_line = true }
-- 	else
-- 		new_value = false
-- 		vim.diagnostic.config({ virtual_lines = new_value })
-- 	end

-- 	vim.diagnostic.config({ virtual_lines = new_value })
-- 	return new_value
-- end

function M.setup()
	M.load_basics()
	M.load_telescope()
end
-- M.load_plugins()

return M

