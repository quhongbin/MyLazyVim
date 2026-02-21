return {
  {
    -- 定义一个编译并运行 C++ 的函数
    -- 定义 Cpp 命令，支持 run/build/test 子命令
    vim.api.nvim_create_user_command("Cpp", function(opts)
      -- 1. 解析参数
      -- opts.fargs 是一个列表，包含命令后面的单词
      -- 例如输入 ":Cpp run"，fargs[1] 就是 "run"
      local subcmd = opts.fargs[1] or "run" -- 默认行为设为 run
      local custom_name = opts.fargs[2] -- 第二个参数：自定义输出文件名（可选）

      -- 2. 获取文件信息
      local file_path = vim.fn.expand("%:p") -- 当前文件绝对路径
      local file_base = vim.fn.expand("%:t:r") -- 无后缀文件名
      local output_name = custom_name or file_base

      -- Windows 兼容性处理
      if vim.fn.has("win32") == 1 then
        output_name = output_name .. ".exe"
      end

      -- 3. 定义基础编译器设置
      local compiler = "g++"
      local std_flag = "-std=c++17" -- 指定 C++ 标准
      local common_flags = "-Wall -g" -- 常用警告和调试信息

      -- 4. 根据子命令构建具体的 Shell 命令
      local cmd = ""

      if subcmd == "build" then
        -- build: 仅编译
        cmd = string.format(
          "%s %s %s %s -o %s",
          compiler,
          std_flag,
          common_flags,
          vim.fn.shellescape(file_path),
          output_name
        )
        print("Building " .. file_base .. "...")
      elseif subcmd == "run" then
        -- run: 编译并运行
        cmd = string.format(
          "%s %s %s %s -o %s && ./%s || %s",
          compiler,
          std_flag,
          common_flags,
          vim.fn.shellescape(file_path),
          output_name,
          output_name,
          output_name
        )
      elseif subcmd == "test" then
        -- test: 编译并运行 (这里示例添加了 AddressSanitizer 检测内存错误)
        -- 如果不想用 sanitizer，可以改为和 run 一样
        local test_flags = "-fsanitize=address -fsanitize=undefined"
        cmd = string.format(
          "%s %s %s %s %s -o %s && ./%s || %s",
          compiler,
          std_flag,
          common_flags,
          test_flags,
          vim.fn.shellescape(file_path),
          output_name,
          output_name,
          output_name
        )
        print("Testing with Sanitizers...")
      else
        print("Unknown Cpp subcommand: " .. subcmd)
        return
      end

      -- 5. 在终端中执行
      -- vsplit: 垂直分割窗口
      -- terminal: 打开终端
      vim.cmd("split | terminal " .. cmd)
      vim.cmd("startinsert") -- 自动进入插入模式
    end, {
      nargs = "*", -- 接受任意数量的参数
      complete = function() -- Tab 补全函数
        return { "run", "build", "test" }
      end,
      desc = "C++ Tools: run, build, test",
    }),
  },
}
