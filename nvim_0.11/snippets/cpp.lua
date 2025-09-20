return {
  s("sac", {
    t({"SacAbortIfNot("}), i(1), t({", fail);"}), i(2),
  }),
  s("stc", {
    t({"static_cast<"}), i(1), t({">("}), i(2), t(")")} ),
  s("todo", d(1, function()
      local branch = vim.fn.trim(vim.fn.system("git branch --show-current"))
      local ticket = branch:match("SATSW%-%d+") or "<ticket>"
      return sn(nil, {t("TODO (" .. ticket .. "): ")})
  end)),
  }, {
  s("result", t("result_t")),
  s("u8", t("uint8_t")),
  s("u16", t("uint16_t")),
  s("u32", t("uint32_t")),
  s("i8", t("int8_t")),
  s("i16", t("int16_t")),
  s("i32", t("int32_t")),
  s("dst", t("digital_sample_t")),
  s("szt", t("size_t")),
  postfix(".sac", {
    f(function(_, parent)
        return "SacAbortIfNot(" .. parent.snippet.env.POSTFIX_MATCH .. ", fail);"
    end, {}),
  })
}
