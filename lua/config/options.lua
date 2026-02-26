-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

-- neovim configure of clipboard with xclip(apt package)
opt.clipboard = "unnamedplus"

-- call user command under quickly_cmd directory
local cmd_path = vim.fn.stdpath("config") .. "/lua/config/quickly_cmd"
-- 检查目录是否存在
if vim.fn.isdirectory(cmd_path) == 1 then
  -- 扫描 lua/config/quickly_cmd/*.lua 文件
  local files = vim.fn.glob(cmd_path .. "/*.lua", true, true)
  for _, file in ipairs(files) do
    -- 提取文件名作为模块名 (例如 cpp.lua -> cpp)
    local module_name = vim.fn.fnamemodify(file, ":t:r")
    local module_path = "config.quickly_cmd." .. module_name

    -- 安全加载模块
    local ok, module = pcall(require, module_path)
    if ok and type(module.cpp_run) == "function" then
      module.cpp_run() -- 执行模块的 setup 函数
    else
      vim.notify("Failed to load module: " .. module_path, vim.log.levels.WARN)
    end
  end
end
