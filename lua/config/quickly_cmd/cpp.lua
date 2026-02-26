-- lua/config/quickly_cmd/cpp.lua
local M = {}

-- 定义加载函数
M.cpp_run = function()
  -- 监听 FileType 事件，仅当打开 C++ 文件时才执行内部逻辑
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "cpp",
    callback = function()
      vim.g.snacks_animate = false
      -- 1. 定义 :Cpp 用户命令
      vim.api.nvim_create_user_command("CppRun", function()
        -- 获取当前文件路径
        local file_path = vim.fn.expand("%:p")
        local file_noext = vim.fn.expand("%:p:r")
        local out_binary = file_noext .. ".out"

        -- 构建编译与运行命令
        -- -Wall: 开启警告, -g: 调试信息, &&: 编译成功后运行
        local cmd = string.format('g++ -Wall -g "%s" -o "%s" && "%s"', file_path, out_binary, out_binary)
        -- 安全调用 Snacks 终端
        -- 使用 pcall 防止 Snacks 未加载时报错
        local ok, snacks = pcall(require, "snacks")
        if not ok then
          vim.notify("Snacks.nvim 未加载，无法使用终端功能。", vim.log.levels.ERROR)
          return
        end

        -- 调用 Snacks.terminal
        snacks.terminal.open(cmd, {
          auto_close = false,
        })
      end, { desc = "Compile and Run C++ (Snacks Terminal)", force = true })

      -- 2. 定义快捷键 (仅在当前 C++ buffer 中生效)
      vim.keymap.set("n", "<leader>cp", "<cmd>CppRun<cr>", {
        desc = "Compile and Run C++",
        buffer = 0, -- 仅绑定到当前缓冲区
      })
    end,
    -- FileType event
  })
end

return M
