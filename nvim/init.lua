require("config.lazy-bootstrap")

vim.g.mapleader = ";"
vim.g.maplocalleader = ";"
vim.g.have_nerd_font = true
local colorscheme = "catppuccin"
local is_nixos = (string.find(vim.fn.system("lsb_release -a"), "NixOS") ~= nil)

require("config.opts")

-- Setup lazy.nvim
require("lazy").setup({

    -- colorscheme
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = {
            transparent_background = true;
            flavor = "macchiato",
            background = {
                light = "frappe",
                dark = "macchiato",
            }

        }
    },
    'vmchale/just-vim',
    {
      "christoomey/vim-tmux-navigator",
      cmd = {
        "TmuxNavigateLeft",
        "TmuxNavigateDown",
        "TmuxNavigateUp",
        "TmuxNavigateRight",
        "TmuxNavigatePrevious",
      },
      keys = {
        { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
        { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
        { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
        { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
        { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
      },
    },
    { "tpope/vim-sleuth" },

    -- Telescope
    {
        "nvim-telescope/telescope.nvim",
        event = "VimEnter",  -- right after done loading 
        branch = '0.1.x',
        dependencies = {
            "nvim-lua/plenary.nvim",
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make", -- runs on install
                cond = function() 
                    return vim.fn.executable("make") == 1
                end
            },
            "nvim-telescope/telescope-ui-select.nvim",
            { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font }
        },

        config = function()
            require("telescope").setup({
                extensions = {
                    ['ui-select'] = {
                        require("telescope.themes").get_dropdown(),
                    },

                    ["file_browser"] = {
                        hijack_netrw = true,
                    },
                    fzf = {
                      fuzzy = true,                    -- false will only do exact matching
                      override_generic_sorter = true,  -- override the generic sorter
                      override_file_sorter = true,     -- override the file sorter
                      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                    }
                }
            })
            pcall(require('telescope').load_extension, 'fzf')
            pcall(require('telescope').load_extension, 'ui-select')
            pcall(require('telescope').load_extension, 'file_browser')
        end
        -- NOTE: telescope keymaps are loaded with other keymaps
    },

    -- Autocomplete
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            {
                "L3MON4D3/LuaSnip",
                build = (function()
                    if vim.fn.has "win32" == 1 or vim.fn.executable "make" == 0 then
                        return
                    end 
                    return "make install_jsregexp"
                end
                )(),
                dependencies = {
                    {
                        "rafamadriz/friendly-snippets",
                        config = function()
                            require("luasnip.loaders.from_vscode").lazy_load()
                        end,
                    }
                },
            },
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            luasnip.config.setup({})
            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    completion = cmp.config.window.bordered(),
                },
                completion = { completeopt = "menu,menuone,noinsert" },
                mapping = cmp.mapping.preset.insert({

                -- -- Select the [n]ext item
                -- ['<C-n>'] = cmp.mapping.select_next_item(),
                -- -- Select the [p]revious item
                -- ['<C-p>'] = cmp.mapping.select_prev_item(),

                -- -- Scroll the documentation window [b]ack / [f]orward
                -- ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                -- ['<C-f>'] = cmp.mapping.scroll_docs(4),

                -- -- Accept ([y]es) the completion.
                -- --  This will auto-import if your LSP supports it.
                -- --  This will expand snippets if the LSP sent a snippet.
                -- -- ['<C-y>'] = cmp.mapping.confirm { select = true },

                -- If you prefer more traditional completion keymaps,
                -- you can uncomment the following lines
                ['<CR>'] = cmp.mapping.confirm { select = true },
                ['<Tab>'] = cmp.mapping.select_next_item(),
                ['<S-Tab>'] = cmp.mapping.select_prev_item(),

                -- -- Manually trigger a completion from nvim-cmp.
                -- --  Generally you don't need this, because nvim-cmp will display
                -- --  completions whenever it has completion options available.
                -- ['<C-Space>'] = cmp.mapping.complete {},

                -- -- Think of <c-l> as moving to the right of your snippet expansion.
                -- --  So if you have a snippet that's like:
                -- --  function $name($args)
                -- --    $body
                -- --  end
                -- --
                -- -- <c-l> will move you to the right of each of the expansion locations.
                -- -- <c-h> is similar, except moving you backwards.
                -- ['<C-l>'] = cmp.mapping(function()
                --     if luasnip.expand_or_locally_jumpable() then
                --     luasnip.expand_or_jump()
                --     end
                -- end, { 'i', 's' }),
                -- ['<C-h>'] = cmp.mapping(function()
                --     if luasnip.locally_jumpable(-1) then
                --     luasnip.jump(-1)
                --     end
                -- end, { 'i', 's' }),
                -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
                --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps

                }),
                sources = {
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                    { name = 'path' },
                    { name = 'treesitter' },
                    -- { name = 'crates' },
                }
            })
        end
    },

    -- LSP 
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            { "williamboman/mason.nvim", config = true},
            "williamboman/mason-lspconfig.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim", -- for other tools
            "j-hui/fidget.nvim",
            -- { 'folke/neodev.nvim', opts = {} }, -- LSP for Neovim config
        },
        opts = function()
            local ret = {
                servers =  {
                    gopls = {},
                    html = {},
                    htmx = {},
                    rust_analyzer = {
                        mason = not is_nixos,
                    },
                    basedpyright = {
                        mason = not is_nixos,
                    },
                    ruff = {
                        mason = not is_nixos,
                    },
                    lua_ls = {
                        settings = {
                            Lua = {
                                completion = {
                                    callSnippet = 'Replace',
                                },
                            },
                        },
                    },
                    nil_ls = {
                        mason = not is_nixos,
                    },
                    jdtls = {
                        mason = not is_nixos,
                    },

                    clangd = {
                        mason = not is_nixos,
                        cmd = {
                            "clangd",
                            "--background-index",
                            "--clang-tidy",
                            "--log=verbose",
                            "-std=c++20",
                        },
                        -- init_options = {
                        --     fallbackFlags = {
                        --     }
                        -- }
                    },

                },
                setup = {},
            }
            return ret
        end,

        config = function(_, opts)


            local servers = opts.servers
            local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
            local has_blink, blink = pcall(require, "blink.cmp") -- try blink later


            local capabilities = vim.tbl_deep_extend(
                "force",
                {},
                vim.lsp.protocol.make_client_capabilities(),
                has_cmp and cmp_nvim_lsp.default_capabilities() or {},
                has_blink and blink.get_lsp_capabilities() or {}
                -- opts.capabilities or {}
            )

            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
                callback = function(event)
                    local builtin = require("telescope.builtin")
                    local map = function(input, output, desc)
                        vim.keymap.set('n', input, output, { buffer = event.buf, desc = "LSP: " .. desc})
                    end

                    -- gotos
                    map("gd", builtin.lsp_definitions, "[g]oto [d]efinition")
                    map("gD", vim.lsp.buf.declaration, "[g]oto [D]eclaration")
                    map("gr", builtin.lsp_references, "[g]oto [r]eferences")
                    map("gI", builtin.lsp_implementations, "[g]oto [I]mplementation")
                    map("gs", builtin.lsp_document_symbols, "[g]oto [s]ymbols")
                    map("gS", builtin.lsp_dynamic_workspace_symbols, "[g]oto workspace [S]ymbols")
                    map("<leader>rn", vim.lsp.buf.rename, "[r]e[n]ame")
                    map("<leader>ca", vim.lsp.buf.code_action, "[c]ode [a]ction")
                    map("gh", vim.lsp.buf.hover, "[g]oto [h]elp (Hover Documentation)")


                    local client = vim.lsp.get_client_by_id(event.data.client_id)

                    if client and client.server_capabilities.documentHighlightProvider and vim.lsp.inlay_hint then 
                        map("<leader>th", function()
                            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
                        end, "[t]oggle inlay [h]ints")
                    end
                end,
            })



            local function setup(server)
                local server_opts = vim.tbl_deep_extend("force", {
                    capabilities = vim.deepcopy(capabilities),
                }, servers[server] or {})

                if server_opts.enabled == false then
                    return
                end
                if opts.setup[server] then
                    if opts.setup[server](server, server_opts) then
                      return
                    end
                elseif opts.setup["*"] then
                    if opts.setup["*"](server, server_opts) then
                        return
                    end
                end
                require("lspconfig")[server].setup(server_opts)
            end

            local have_mason, mlsp = pcall(require, "mason-lspconfig")

            local ensure_installed = {}

            for server, server_opts in pairs(servers) do
                if server_opts then 
                    server_opts = server_opts == true and {} or server_opts
                    if server_opts.enabled ~= false then 
                        -- if we're not using mason for this server OR mason doesn't have this server
                        if server_opts.mason == false then --or not vim.tbl_contains(all_mslp_servers, server) then
                            setup(server)
                        else
                        -- otherwise, add it to the ensure_installed list
                            ensure_installed[#ensure_installed + 1] = server
                        end
                    end
                end
            end

            if have_mason then
                mlsp.setup({
                    ensure_installed = vim.tbl_deep_extend(
                        "force",
                        ensure_installed,
                        require("mason-lspconfig").ensure_installed or {}
                    ),
                    handlers = { setup },
                })
            end

            local lspconfig = require("lspconfig")
            lspconfig.clangd.setup({
                cmd = { "clangd", "--background-index", "--clang-tidy", "--log=verbose" },
                init_options = {
                    fallbackFlags = { "-std=c++17" },
                },
            })
        end
    },

    -- treesitter
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        opts = {
        ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'vim', 'vimdoc' },
        -- Autoinstall languages that are not installed
        auto_install = true,
        highlight = {
            enable = true,
            disable = { "c", "rust", "python" },
            -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
            --  If you are experiencing weird indenting issues, add the language to
            --  the list of additional_vim_regex_highlighting and disabled languages for indent.
            additional_vim_regex_highlighting = { 'ruby' },
        },
        indent = { enable = true, disable = { 'ruby' } },
        },
        config = function(_, opts)
        -- [[ Configure Treesitter ]] See `:help nvim-treesitter`

        -- Prefer git instead of curl in order to improve connectivity in some environments
            require('nvim-treesitter.install').prefer_git = true
            ---@diagnostic disable-next-line: missing-fields
            require('nvim-treesitter.configs').setup(opts)

        -- There are additional nvim-treesitter modules that you can use to interact
        -- with nvim-treesitter. You should go explore a few and see what interests you:
        --
        --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
        --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
        --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
        end,
    },
    -- {
    --     'lewis6991/gitsigns.nvim',
    --     opts = {},
    -- },

    {
      'stevearc/oil.nvim',
      ---@module 'oil'
      ---@type oil.SetupOpts
      opts = {},
      -- dependencies = { { "echasnovski/mini.icons", opts = {} } },
      dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
      lazy = false,
    },
    {
      "folke/trouble.nvim",
      opts = {}, -- for default options, refer to the configuration section for custom setup.
      cmd = "Trouble",
      keys = {
        {
          "<leader>xx",
          "<cmd>Trouble diagnostics toggle<cr>",
          desc = "Diagnostics (Trouble)",
        },
        {
          "<leader>xX",
          "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
          desc = "Buffer Diagnostics (Trouble)",
        },
        {
          "<leader>cs",
          "<cmd>Trouble symbols toggle focus=false<cr>",
          desc = "Symbols (Trouble)",
        },
        {
          "<leader>cl",
          "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
          desc = "LSP Definitions / references / ... (Trouble)",
        },
        {
          "<leader>xL",
          "<cmd>Trouble loclist toggle<cr>",
          desc = "Location List (Trouble)",
        },
        {
          "<leader>xQ",
          "<cmd>Trouble qflist toggle<cr>",
          desc = "Quickfix List (Trouble)",
        },
      },
    },

    {
        'mfussenegger/nvim-dap',
        dependencies = {
            'rcarriga/nvim-dap-ui',
            'nvim-neotest/nvim-nio',
            'williamboman/mason.nvim',
            'jay-babu/mason-nvim-dap.nvim',
            'leoluz/nvim-dap-go',
        },
        keys = function(_, keys)
            local dap = require 'dap'
            local dapui = require 'dapui'
            return {
            -- Basic debugging keymaps, feel free to change to your liking!
            { '<F5>', dap.continue, desc = 'Debug: Start/Continue' },
            { '<F1>', dap.step_into, desc = 'Debug: Step Into' },
            { '<F2>', dap.step_over, desc = 'Debug: Step Over' },
            { '<F3>', dap.step_out, desc = 'Debug: Step Out' },
            { '<leader>b', dap.toggle_breakpoint, desc = 'Debug: Toggle Breakpoint' },
            {
                '<leader>B',
                function()
                dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
                end,
                desc = 'Debug: Set Breakpoint',
            },
            { '<F7>', dapui.toggle, desc = 'Debug: See last session result.' },
            unpack(keys),
            }
        end,
        config = function()
            local dap = require 'dap'
            local dapui = require 'dapui'
            require('mason-nvim-dap').setup {
                -- Makes a best effort to setup the various debuggers with
                -- reasonable debug configurations
                automatic_installation = true,

                -- You can provide additional configuration to the handlers,
                -- see mason-nvim-dap README for more information
                handlers = {},

                -- You'll need to check that you have the required things installed
                -- online, please don't ask me how to install them :)
                ensure_installed = {
                    -- Update this to ensure that you have the debuggers for the langs you want
                },
            }

            dapui.setup {
                icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
                controls = {
                    icons = {
                    pause = '⏸',
                    play = '▶',
                    step_into = '⏎',
                    step_over = '⏭',
                    step_out = '⏮',
                    step_back = 'b',
                    run_last = '▶▶',
                    terminate = '⏹',
                    disconnect = '⏏',
                    },
                },
            }

            dap.listeners.after.event_initialized['dapui_config'] = dapui.open
            dap.listeners.before.event_terminated['dapui_config'] = dapui.close
            dap.listeners.before.event_exited['dapui_config'] = dapui.close

            -- Install golang specific config
            require('dap-go').setup {
                delve = {
                    -- On Windows delve must be run attached or it crashes.
                    -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
                    detached = vim.fn.has 'win32' == 0,
                },
            }
        end,
    },


    -- lazy settings
    -- { import = "plugins" }, -- import specs from lua/plugins/

    install = {
        missing = true,                 -- install missing plugins
        colorscheme = { "catppuccin" }, -- preload colorscheme
    },

})

require("config.keymaps").setup()

local ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not ok then
    vim.notify("colorscheme " .. colorscheme " not found...")
end

