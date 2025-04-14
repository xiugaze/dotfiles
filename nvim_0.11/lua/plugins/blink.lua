return {
  "saghen/blink.cmp",
  dependencies = { 'rafamadriz/friendly-snippets' },
  version = '1.*',
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    -- See :h blink-cmp-config-keymap for defining your own keymap
    keymap = {
      preset = 'enter',
      ['<S-enter>'] = {
        function(cmp) cmp.accept({ index = 1 }) end,
      }

    },

    appearance = {
      nerd_font_variant = 'mono'
    },

    -- (Default) Only show the documentation popup when manually triggered
    completion = {
      documentation = {
        auto_show = false
      },
      list = { selection = { preselect = false } },
    },
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
      providers = {
        buffer = {
          -- keep case of first char
          transform_items = function(a, items)
            local keyword = a.get_keyword()
            local correct, case
            if keyword:match('^%l') then
              correct = '^%u%l+$'
              case = string.lower
            elseif keyword:match('^%u') then
              correct = '^%l+$'
              case = string.upper
            else
              return items
            end

            -- avoid duplicates from the corrections
            local seen = {}
            local out = {}
            for _, item in ipairs(items) do
              local raw = item.insertText
              if raw:match(correct) then
                local text = case(raw:sub(1, 1)) .. raw:sub(2)
                item.insertText = text
                item.label = text
              end
              if not seen[item.insertText] then
                seen[item.insertText] = true
                table.insert(out, item)
              end
            end
            return out
          end
        }
      }
    },

    fuzzy = { implementation = "prefer_rust_with_warning" }
  },
  opts_extend = { "sources.default" },
  signature = { enabled = true },
}
