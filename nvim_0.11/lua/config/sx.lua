local function open_jira_ticket()
  vim.cmd('normal! "<Esc>"')
  vim.cmd('normal! "ay')

  local selected_text = vim.fn.getreg('a'):gsub('%s+', ' '):gsub('^%s*(.-)%s*$', '%1')

  if not selected_text:match("^%u+%-%d+$") then
    vim.notify("Error: Invalid ticket format (expected: PROJECT-123)", vim.log.levels.ERROR)
    return
  end

  vim.notify("Opening Jira ticket: " .. selected_text, vim.log.levels.INFO)

  local jira_url = "https://jira.spacex.corp/browse/" .. selected_text
  vim.fn.system("xdg-open " .. vim.fn.shellescape(jira_url))
end


local function copy_jira_ticket()
  vim.cmd('normal! "<Esc>"')
  vim.cmd('normal! "ay')
  local selected_text = vim.fn.getreg('a'):gsub('%s+', ' '):gsub('^%s*(.-)%s*$', '%1')

  if not selected_text:match("^%u+%-%d+$") then
    vim.notify("Invalid ticket format (expected: PROJECT-123)", vim.log.levels.ERROR)
    return
  end

  vim.fn.setreg('+', "https://jira.spacex.corp/browse/" .. selected_text)
end


vim.keymap.set('v', '<leader>to', open_jira_ticket, { desc = "Open Jira ticket" })
vim.keymap.set('v', '<leader>ty', copy_jira_ticket, { desc = "Copy Jira ticket" })

local function blame_ticket_to_clipboard()
  local file = vim.fn.expand('%')
  local lnum = vim.fn.line('.')
  if file == '' or lnum == 0 then return end

  local cmd = string.format('git blame -L %d,%d -p -- %s', lnum, lnum, file)
  local handle = io.popen(cmd)
  if not handle then return end
  local raw = handle:read('*a')
  handle:close()

  local commit = raw:match('^(%x+)')
  if not commit then return end

  local msg_cmd = string.format('git log -1 --pretty=%%B %s', commit)
  handle = io.popen(msg_cmd)
  if not handle then return end
  local msg = handle:read('*a'):gsub('%s+$', '')
  handle:close()

  vim.notify(msg, vim.log.levels.INFO)

  local ticket = msg:match('([A-Z]+%-?%w+)')
  if not ticket then
    vim.notify('No ticket found in commit message', vim.log.levels.WARN)
    return
  end

  vim.fn.setreg('+', 'https://jira.spacex.corp/browse/' ..ticket)
  vim.notify('Copied ticket link: ' .. ticket, vim.log.levels.INFO)
end


vim.keymap.set("n", "<leader>tg", blame_ticket_to_clipboard)
