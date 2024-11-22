require("config.lazy-bootstrap")

vim.g.mapleader = ";"
vim.g.maplocalleader = ";"
vim.g.have_nerd_font = true
local colorscheme = "catppuccin"

require("config.opts")

-- Setup lazy.nvim
require("lazy").setup({

    -- colorscheme
    { 
        "catppuccin/nvim", 
        name = "catppuccin", 
        priority = 1000,
        config = {
            flavor = "macchiato",
            background = {
                light = "frappe",
                dark = "macchiato",
            }

        }
    },
    {
        "tpope/vim-sleuth"
    },
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
                    -- is make executable
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

                -- -- If you prefer more traditional completion keymaps,
                -- -- you can uncomment the following lines
                -- ['<CR>'] = cmp.mapping.confirm { select = true },
                -- --['<Tab>'] = cmp.mapping.select_next_item(),
                -- --['<S-Tab>'] = cmp.mapping.select_prev_item(),

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

        config = function()
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

                    -- if the current LSP supports inlay hints?
                    if client and client.server_capabilities.documentHighlightProvider and vim.lsp.inlay_hint then 
                        map("<leader>th", function()
                            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
                        end, "[t]oggle inlay [h]ints")
                    end
                end,
            })

            -- add cmp capabilities to client capabilities
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

            local servers = {
                -- clangd = {
                --     cmd = {
                --         "clangd",
                --         "--background-index",
                --         "--clang-tidy",
                --         "--log=verbose",
                --     },
                --     init_options = {
                --         fallbackFlags = {
                --             "-std=c++17"
                --         }
                --     }
                -- },
                nil_ls = {},
                lua_ls = {
                    -- cmd = {...},
                    -- filetypes = { ...},
                    -- capabilities = {},
                    settings = {
                        Lua = {
                            completion = {
                                callSnippet = 'Replace',
                            },
                        },
                    },
                },
                ocamllsp = {},
            }

            local lspconfig = require('lspconfig')
            lspconfig.clangd.setup({
                cmd = {'clangd', '--background-index', '--clang-tidy', '--log=verbose'},
                init_options = {
                    fallbackFlags = { '-std=c++17' },
                },
            })

            lspconfig.opts = {
                servers = {
                    clangd = {
                        mason = false,
                    },
                    ocamllsp = {
                        mason = false,
                    },

                },
            }
            require("mason").setup()
            local ensure_installed = vim.tbl_keys(servers or {})
            require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
            require("mason-lspconfig").setup({
                handlers = {
                    function(server_name)
                        local server = servers[server_name] or {}
                        -- add specific capabilities from each server
                        server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
                        require("lspconfig")[server_name].setup(server)
                    end
                }
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
            enable = disable,
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

    {
        -- NOTE: Yes, you can install new plugins here!
        'mfussenegger/nvim-dap',
        -- NOTE: And you can specify dependencies as well
        dependencies = {
            -- Creates a beautiful debugger UI
            'rcarriga/nvim-dap-ui',

            -- Required dependency for nvim-dap-ui
            'nvim-neotest/nvim-nio',

            -- Installs the debug adapters for you
            'williamboman/mason.nvim',
            'jay-babu/mason-nvim-dap.nvim',

            -- Add your own debuggers here
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
            -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
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

            -- Dap UI setup
            -- For more information, see |:help nvim-dap-ui|
            dapui.setup {
            -- Set icons to characters that are more likely to work in every terminal.
            --    Feel free to remove or use ones that you like more! :)
            --    Don't feel like these are good choices.
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

-- load keymaps
require("config.keymaps").setup()

-- set colorscheme
local ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not ok then
    vim.notify("colorscheme " .. colorscheme " not found...")
end

