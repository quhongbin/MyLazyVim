local ls = require("luasnip")
local snippet = ls.snippet
local textNode = ls.text_node
local insertNode = ls.insert_node
local functiionNode = ls.function_node

local function handle(_, _, user_arg_1)
  return user_arg_1
end

return {
  snippet("#individual_info", {
    textNode({
      "/*************************************************************************",
      "> File Name: " .. vim.fn.fnamemodify(vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()), ":t"),
      "> Author: quhongbin",
      "> Mail: 2818777520@qq.com",
      "> Created Time: " .. os.date("!%c", os.time()),
      "************************************************************************/",
    }),
    -- functiionNode(handle, {}, { user_args = { "test text" } }),
  }),
}
