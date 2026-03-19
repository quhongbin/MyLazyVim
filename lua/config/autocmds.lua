-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- resize splits if window got resized
-- 定义文件类型配置表（仅设置选项，不包含保存）
local filetype_options = {
  python = function()
    vim.bo.expandtab = true
    vim.bo.shiftwidth = 4
  end,
  ["*.lua"] = function()
    vim.bo.shiftwidth = 2
    vim.wo.wrap = false
  end,
  ["*.c,*.cpp,*.h,*.java,*.go"] = function()
    vim.bo.shiftwidth = 4
    vim.bo.cindent = true
  end,
}

-- 在 FileType 事件时设置文件类型选项
for ft_pattern, config_func in pairs(filetype_options) do
  vim.api.nvim_create_autocmd("FileType", {
    pattern = vim.split(ft_pattern, ","),
    callback = config_func,
    desc = "Filetype options for: " .. ft_pattern,
  })
end

-- 保存文件的 autocmd（离开 buffer 或退出 Insert 模式时保存）
local filetype_save = {
  python = function()
    vim.cmd("%s/\\s\\+$//e")
  end,
}
vim.api.nvim_create_autocmd({ "InsertLeave", "BufLeave" }, {
  pattern = { "*.py", "*.lua", "*.c", "*.cpp", "*.h", "*.java", "*.go" },
  callback = function(args)
    local ft = vim.bo[args.buf].filetype
    if filetype_save[ft] then
      filetype_save[ft]()
    end
    if vim.bo[args.buf].modified then
      vim.cmd("w")
    end
  end,
  desc = "Save file on InsertLeave or BufLeave",
})

-- md file off spelling
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = { "*.md" },
  callback = function()
    vim.bo.spelllang = "en_us" -- 拼写检查语言（仅当前文件）
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
