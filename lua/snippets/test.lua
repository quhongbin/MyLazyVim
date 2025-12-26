local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  -- 输入 `note` → 生成 markdown 笔记标题
  s("note", {
    t("# "),
    i(1, "笔记标题"),
    t({ "", "**日期**：" }),
    i(2, os.date("%Y-%m-%d")), -- 自动填充当前日期
  }),
}
