return {
  {
    vim.api.nvim_create_user_command("Run", function(lang)
      vim.notify(vim.bo.filetype, vim.log.levels.INFO)
      vim.notify(lang, vim.log.levels.INFO)
      -- get the filetype
      if vim.bo.filetype == lang then
        vim.notify("test", vim.log.levels.INFO)
      end
    end, {
      desc = "print hello Wolrd",
      nargs = "?",
      complete = function()
        return { "qhb", "qhb1" }
      end,
    }),
    -- 功能二
    vim.api.nvim_create_user_command("Test", function()
      vim.cmd("w") -- 保存文件
      local file = vim.fn.expand("%") -- 当前文件路径

      -- 异步执行 python 脚本
      vim.system({ "python3", file }, { text = true }, function(res)
        -- 关键：用 vim.schedule 包裹 UI 操作，避开 Fast Event Context
        vim.schedule(function()
          -- 1. 创建浮动窗口（现在在非 Fast 上下文，允许执行）
          local buf = vim.api.nvim_create_buf(false, true) -- 创建临时缓冲区
          local win = vim.api.nvim_open_win(buf, true, {
            relative = "editor",
            width = vim.o.columns - 20,
            height = vim.o.lines - 10,
            row = 5,
            col = 10,
          })

          -- 2. 将输出写入缓冲区
          local output = res.stdout or res.stderr -- 取标准输出/错误输出
          vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(output, "\n"))

          -- 3. 窗口失去焦点时自动关闭（可选）
          vim.api.nvim_create_autocmd("WinLeave", {
            buffer = buf,
            callback = function()
              vim.api.nvim_win_close(win, true)
            end,
          })
        end)
      end)
    end, {
      desc = "Async run Python file (float window)",
    }),
  },
}
