return {
  s("name", t("Caleb Andreano")),
  s("todo", d(1, function()
      local branch = vim.fn.trim(vim.fn.system("git branch --show-current"))
      local ticket = branch:match("SATSW%-%d+") or "<ticket>"
      return sn(nil, {t("TODO (" .. ticket .. "): ")})
  end)),
  s("note", d(1, function()
      local branch = vim.fn.trim(vim.fn.system("git branch --show-current"))
      local ticket = branch:match("SATSW%-%d+") or "<ticket>"
      return sn(nil, {t("NOTE (" .. ticket .. "): ")})
  end)),
}
