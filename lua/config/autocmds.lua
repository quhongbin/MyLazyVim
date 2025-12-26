-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- resize splits if window got resized
-- 定义文件类型配置表
local filetype_configs = {
  python = function()
    vim.bo.expandtab = true
    vim.bo.shiftwidth = 4
    -- 保存时去行尾空格
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = 0,
      callback = function()
        vim.cmd("%s/\\s\\+$//e")
      end,
    })
    vim.cmd("w")
  end,
  lua = function()
    vim.bo.shiftwidth = 2
    vim.wo.wrap = false
    vim.cmd("w")
  end,
  ["markdown"] = function()
    vim.wo.wrap = true
    vim.bo.spell = true -- 启用拼写检查（仅当前 Markdown 文件）
    -- vim.bo.spelllang = "en_us" -- 拼写检查语言（仅当前文件）
    vim.cmd("w")
  end,
  ["c,cpp,java,go"] = function() -- 批量匹配用逗号分隔
    vim.bo.shiftwidth = 4
    vim.bo.cindent = true
    vim.cmd("w")
  end,
}

-- 批量创建 autocmd
for ft_pattern, config_func in pairs(filetype_configs) do
  vim.api.nvim_create_autocmd("InsertLeave", {
    pattern = vim.split(ft_pattern, ","), -- 分割逗号为列表
    callback = config_func,
    desc = "Filetype config for: " .. ft_pattern,
  })
end

-- md file off spelling
vim.api.nvim_create_autocmd("BufReadPre", {
  pattern = { "*.markdown,*.md" },
  callback = function()
    vim.opt.spell = false
  end,
  once = false,
})

-- C code snippt function
-- vim.api.nvim_create_autocmd("BufReadPre", {
--   pattern = { "*.c" },
--   callback = function()
--     vim.api.nvim_buf_set_lines(vim.api.nvim_get_current_buf(), 0, -1, false, {
--       "/*************************************************************************",
--       "> File Name: " .. vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t"),
--       "> Author: quhongbin",
--       "> Mail: 2818777520@qq.com ",
--       "> Created Time: " .. os.date("%a %b %d %H:%M %Y", os.time()),
--       "************************************************************************/",
--     })
--   end,
-- })
