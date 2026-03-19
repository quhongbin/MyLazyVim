-- 热更新autocmds配置的函数
function _G.reload_autocmds()
  -- 清除自定义自动命令组（推荐给autocmd分组，避免清掉插件的）
  vim.api.nvim_clear_autocmds({ group = "user_autocmds" })

  -- 重新加载autocmds.lua文件
  local autocmd_path = vim.fn.stdpath("config") .. "/config/autocmds.lua"
  -- 先删除已加载的模块缓存，确保加载最新版本
  package.loaded["config.autocmds"] = nil

  -- 安全加载文件，带错误提示
  local ok, err = pcall(dofile, autocmd_path)
  if ok then
    vim.notify("Autocmds reloaded successfully!", vim.log.levels.INFO)
  else
    vim.notify("Failed to reload autocmds: " .. err, vim.log.levels.ERROR)
  end
end

-- 可选：设置快捷键，比如 <leader>ra 触发热更新
vim.keymap.set("n", "rl", "<cmd>lua reload_autocmds()<cr>", {
  desc = "Reload autocmds configuration",
  silent = true,
})
