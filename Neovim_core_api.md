# Neovim 核心 API 与函数中文参考手册

## 前言

本手册基于 Neovim 0.9+ 稳定版，整理了**最常用、最核心**的 Lua API（Neovim 主推）和兼容 Vimscript 的函数，按功能模块分类并附带中文释义、语法、功能说明及示例。Neovim 全部 API 可通过官方文档查询（`:help lua-api` 或 `:help nvim_<api名>`），本手册聚焦日常开发高频使用的接口，便于快速查阅。

### 核心说明

1. Neovim 的 Lua API 分为两层：

    - 高层封装：`vim.*`（如 `vim.keymap`、`vim.diagnostic`），易用性高；

    - 底层 C 绑定：`vim.api.*`（如 `vim.api.nvim_buf_get_lines`），功能更基础、性能更高。

2. Vimscript 函数可通过 `vim.fn.<函数名>` 在 Lua 中调用（如 `vim.fn.expand('%')`）。

3. 所有 API 示例均为 Lua 语法（Neovim 推荐开发方式）。

## 一、全局基础 API（vim.*）

|API 名称（中文）|语法|功能说明|示例|
|---|---|---|---|
|通知提示|`vim.notify(msg, level?, opts?)`|弹出系统级通知（支持不同级别：info/warn/error）|`vim.notify("保存成功", vim.log.levels.INFO)`|
|打印输出|`vim.print(...)`|更友好的打印（支持表、多参数，替代 `print`）|`vim.print({name = "neovim", version = "0.9"})`|
|执行 Vim 命令|`vim.cmd(cmd)`|执行 Vimscript 命令（字符串/表格式）|`vim.cmd("w") -- 保存文件<br>vim.cmd({ "split", "test.lua" }) -- 分屏打开文件`|
|表合并|`vim.tbl_deep_extend(how, ...)`|深度合并多个表（how："error"/"keep"/"force"）|`local t1 = {a=1}; local t2={b=2}; vim.tbl_deep_extend("force", t1, t2)`|
|表遍历|`vim.tbl_map(fn, tbl)`|对表中每个元素执行函数并返回新表|`vim.tbl_map(function(v) return v*2 end, {1,2,3}) -- 输出 {2,4,6}`|
|表过滤|`vim.tbl_filter(fn, tbl)`|过滤表中符合条件的元素|`vim.tbl_filter(function(v) return v>2 end, {1,2,3}) -- 输出 {3}`|
|延时执行|`vim.defer_fn(fn, timeout)`|延迟 `timeout` 毫秒执行函数|`vim.defer_fn(function() vim.notify("延时提示") end, 1000)`|
|字符串分割|`vim.split(s, sep, opts?)`|按分隔符分割字符串为表|`vim.split("a,b,c", ",") -- 输出 {"a","b","c"}`|
|字符串拼接|`vim.fn.join(tbl, sep?)`|将表拼接为字符串（Vimscript 兼容）|`vim.fn.join({"a","b"}, "-") -- 输出 "a-b"`|
|获取当前工作目录|`vim.fn.getcwd()`|返回当前 Neovim 工作目录路径|`local cwd = vim.fn.getcwd()`|
|路径展开|`vim.fn.expand(pattern)`|展开路径通配符/特殊符号（%: 当前文件，~: 家目录）|`vim.fn.expand("%:p") -- 获取当前文件绝对路径`|
## 二、缓冲区（Buffer）API（vim.api.nvim_buf_*）

缓冲区相关 API 用于操作内存中的文本容器，是编辑的核心。

|API 名称（中文）|语法|功能说明|示例|
|---|---|---|---|
|创建新缓冲区|`vim.api.nvim_create_buf(listed, scratch)`|创建缓冲区（listed：是否加入缓冲区列表；scratch：是否临时缓冲区）|`local buf = vim.api.nvim_create_buf(true, false)`|
|获取当前缓冲区|`vim.api.nvim_get_current_buf()`|返回当前活动缓冲区的 ID（数字）|`local cur_buf = vim.api.nvim_get_current_buf()`|
|获取缓冲区名称|`vim.api.nvim_buf_get_name(buf)`|返回缓冲区关联的文件路径（空缓冲区返回空字符串）|`local buf_name = vim.api.nvim_buf_get_name(cur_buf)`|
|设置缓冲区名称|`vim.api.nvim_buf_set_name(buf, name)`|为缓冲区设置关联的文件名称|`vim.api.nvim_buf_set_name(cur_buf, "new_file.lua")`|
|获取缓冲区行内容|`vim.api.nvim_buf_get_lines(buf, start, end, strict_indexing)`|获取 [start, end) 区间的行（end 为 -1 表示最后一行）|`-- 获取第1-3行（索引从0开始）<br>local lines = vim.api.nvim_buf_get_lines(cur_buf, 0, 3, false)`|
|设置缓冲区行内容|`vim.api.nvim_buf_set_lines(buf, start, end, strict_indexing, lines)`|替换 [start, end) 区间的行为指定行|`vim.api.nvim_buf_set_lines(cur_buf, 0, 1, false, {"print('hello')"})`|
|获取缓冲区文本（精准）|`vim.api.nvim_buf_get_text(buf, start_row, start_col, end_row, end_col, opts?)`|0.8+ 新增，获取指定行列范围的文本（更精准）|`local text = vim.api.nvim_buf_get_text(cur_buf, 0, 0, 0, 5, {})`|
|设置缓冲区文本（精准）|`vim.api.nvim_buf_set_text(buf, start_row, start_col, end_row, end_col, text)`|0.8+ 新增，替换指定行列范围的文本|`vim.api.nvim_buf_set_text(cur_buf, 0, 0, 0, 5, {"world"})`|
|获取缓冲区选项|`vim.api.nvim_buf_get_option(buf, option)`|获取缓冲区局部选项（如 filetype、number）|`local ft = vim.api.nvim_buf_get_option(cur_buf, "filetype")`|
|设置缓冲区选项|`vim.api.nvim_buf_set_option(buf, option, value)`|设置缓冲区局部选项|`vim.api.nvim_buf_set_option(cur_buf, "expandtab", true) -- 空格替代制表符`|
|检查缓冲区有效性|`vim.api.nvim_buf_is_valid(buf)`|判断缓冲区是否存在（未被销毁）|`if vim.api.nvim_buf_is_valid(buf) then ... end`|
|删除缓冲区|`vim.api.nvim_buf_delete(buf, opts?)`|销毁缓冲区（opts：{force=true} 强制删除修改后的缓冲区）|`vim.api.nvim_buf_delete(buf, {force=true})`|
|追加文本到缓冲区|`vim.api.nvim_buf_set_lines(buf, -1, -1, false, lines)`|向缓冲区末尾追加行（-1 表示最后一行之后）|`vim.api.nvim_buf_set_lines(cur_buf, -1, -1, false, {"-- 追加的注释"})`|
## 三、窗口（Window）API（vim.api.nvim_win_*）

窗口是缓冲区的「显示容器」，以下 API 用于操作窗口布局和属性。

|API 名称（中文）|语法|功能说明|示例|
|---|---|---|---|
|创建新窗口|`vim.api.nvim_create_win(buf, enter, opts)`|基于指定缓冲区创建窗口（enter：是否进入窗口；opts：位置/大小）|`local win = vim.api.nvim_create_win(cur_buf, true, {relative="editor", width=80, height=20, row=1, col=1})`|
|获取当前窗口|`vim.api.nvim_get_current_win()`|返回当前活动窗口的 ID（数字）|`local cur_win = vim.api.nvim_get_current_win()`|
|获取窗口关联缓冲区|`vim.api.nvim_win_get_buf(win)`|返回窗口当前显示的缓冲区 ID|`local buf = vim.api.nvim_win_get_buf(cur_win)`|
|设置窗口关联缓冲区|`vim.api.nvim_win_set_buf(win, buf)`|让窗口显示指定缓冲区|`vim.api.nvim_win_set_buf(cur_win, new_buf)`|
|获取窗口宽度|`vim.api.nvim_win_get_width(win)`|返回窗口宽度（字符数）|`local width = vim.api.nvim_win_get_width(cur_win)`|
|设置窗口宽度|`vim.api.nvim_win_set_width(win, width)`|设置窗口宽度|`vim.api.nvim_win_set_width(cur_win, 100)`|
|获取窗口高度|`vim.api.nvim_win_get_height(win)`|返回窗口高度（字符数）|`local height = vim.api.nvim_win_get_height(cur_win)`|
|设置窗口高度|`vim.api.nvim_win_set_height(win, height)`|设置窗口高度|`vim.api.nvim_win_set_height(cur_win, 30)`|
|获取光标位置|`vim.api.nvim_win_get_cursor(win)`|返回窗口光标位置（表：{行, 列}，行从1开始，列从0开始）|`local cursor = vim.api.nvim_win_get_cursor(cur_win) -- {1,0} 表示第一行第一个字符`|
|设置光标位置|`vim.api.nvim_win_set_cursor(win, pos)`|设置窗口光标位置（pos：{行, 列}）|`vim.api.nvim_win_set_cursor(cur_win, {5, 2}) -- 光标移到第5行第3列`|
|检查窗口有效性|`vim.api.nvim_win_is_valid(win)`|判断窗口是否存在（未被关闭）|`if vim.api.nvim_win_is_valid(win) then ... end`|
|关闭窗口|`vim.api.nvim_win_close(win, force)`|关闭窗口（force：强制关闭，忽略修改）|`vim.api.nvim_win_close(win, false)`|
|列出所有窗口|`vim.api.nvim_list_wins()`|返回当前所有有效窗口的 ID 列表|`local wins = vim.api.nvim_list_wins()`|
## 四、自动命令（Autocmd）API

用于创建/管理自动命令（在指定事件触发时执行逻辑）。

|API 名称（中文）|语法|功能说明|示例|
|---|---|---|---|
|创建自动命令组|`vim.api.nvim_create_augroup(name, opts?)`|创建自动命令组（便于批量管理 autocmd）|`local augroup = vim.api.nvim_create_augroup("MyAutoGroup", {clear = true})`|
|创建自动命令|`vim.api.nvim_create_autocmd(event, opts)`|绑定事件到自动命令（核心 API）|`-- 保存前格式化代码<br>vim.api.nvim_create_autocmd("BufWritePre", {<br>  group = augroup,<br>  pattern = "*.lua",<br>  callback = function() vim.lsp.buf.format() end<br>})`|
|删除自动命令|`vim.api.nvim_del_autocmd(id)`|删除指定 ID 的自动命令|`local autocmd_id = vim.api.nvim_create_autocmd(...)<br>vim.api.nvim_del_autocmd(autocmd_id)`|
|触发自动命令|`vim.api.nvim_do_autocmd(event, opts?)`|手动触发指定自动命令事件|`vim.api.nvim_do_autocmd("FileType", {pattern = "lua"})`|
## 五、键映射（Keymap）API

0.7+ 新增高层 `vim.keymap` 接口（推荐），替代旧版 `nvim_set_keymap`。

|API 名称（中文）|语法|功能说明|示例|
|---|---|---|---|
|设置键映射（新版）|`vim.keymap.set(mode, lhs, rhs, opts?)`|绑定按键映射（mode：n/i/v 等模式；lhs：按键；rhs：执行内容）|`-- 普通模式下 jj 退出插入模式<br>vim.keymap.set("i", "jj", "<Esc>", {noremap = true, silent = true})<br>-- 普通模式下 <leader>f 查找文件<br>vim.keymap.set("n", "<leader>f", "<cmd>Telescope find_files<CR>", {desc = "查找文件"})`|
|删除键映射（新版）|`vim.keymap.del(mode, lhs, opts?)`|删除指定按键映射|`vim.keymap.del("i", "jj")`|
|设置键映射（旧版）|`vim.api.nvim_set_keymap(mode, lhs, rhs, opts?)`|底层映射 API（兼容 Vim）|`vim.api.nvim_set_keymap("n", "<leader>s", ":w<CR>", {noremap = true, silent = true})`|
|获取键映射|`vim.api.nvim_get_keymap(mode)`|返回指定模式下的所有映射|`local maps = vim.api.nvim_get_keymap("n")`|
## 六、选项（Option）API

用于读取/设置全局、缓冲区、窗口级别的选项。

|API 名称（中文）|语法|功能说明|示例|
|---|---|---|---|
|设置全局选项（Lua 风格）|`vim.o.option = value`|高层封装，设置全局选项（推荐）|`vim.o.number = true -- 显示行号<br>vim.o.tabstop = 4 -- 制表符宽度4`|
|获取全局选项（Lua 风格）|`local val = vim.o.option`|读取全局选项值|`local is_number = vim.o.number`|
|设置缓冲区选项（Lua 风格）|`vim.bo.option = value`|高层封装，设置缓冲区局部选项|`vim.bo.expandtab = true -- 当前缓冲区用空格替代制表符`|
|设置窗口选项（Lua 风格）|`vim.wo.option = value`|高层封装，设置窗口局部选项|`vim.wo.wrap = false -- 当前窗口禁用换行`|
|底层设置全局选项|`vim.api.nvim_set_option(name, value)`|底层 API，设置全局选项|`vim.api.nvim_set_option("hlsearch", false)`|
|底层获取选项|`vim.api.nvim_get_option(name)`|底层 API，读取全局选项|`local hlsearch = vim.api.nvim_get_option("hlsearch")`|
## 七、寄存器（Register）API

用于操作 Neovim 寄存器（复制/粘贴的核心载体）。

|API 名称（中文）|语法|功能说明|示例|
|---|---|---|---|
|获取寄存器内容|`vim.api.nvim_get_reg(reg)`|返回指定寄存器的内容（reg："" 无名寄存器，"+" 系统剪贴板）|`local clip = vim.api.nvim_get_reg("+") -- 获取系统剪贴板内容`|
|设置寄存器内容|`vim.api.nvim_set_reg(reg, value, regtype?)`|设置寄存器内容（regtype：v/V/ 表示可视模式类型）|`vim.api.nvim_set_reg("+", "hello world") -- 写入系统剪贴板`|
|获取寄存器类型|`vim.api.nvim_get_regtype(reg)`|返回寄存器的内容类型（字符/行/块）|`local regtype = vim.api.nvim_get_regtype("+")`|
## 八、LSP 核心 API（vim.lsp.*）

Neovim 内置 LSP 客户端的核心接口，用于代码补全、跳转、格式化等。

|API 名称（中文）|语法|功能说明|示例|
|---|---|---|---|
|悬浮提示|`vim.lsp.buf.hover()`|显示光标下符号的详情（类型、注释等）|`vim.keymap.set("n", "K", vim.lsp.buf.hover, {desc = "LSP 悬浮提示"})`|
|跳转到定义|`vim.lsp.buf.definition()`|跳转到符号的定义位置|`vim.keymap.set("n", "gd", vim.lsp.buf.definition, {desc = "跳转到定义"})`|
|查找引用|`vim.lsp.buf.references()`|列出符号的所有引用位置|`vim.keymap.set("n", "gr", vim.lsp.buf.references, {desc = "查找引用"})`|
|代码格式化|`vim.lsp.buf.format(opts?)`|格式化当前缓冲区/指定范围代码|`vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, {desc = "代码格式化"})`|
|重命名符号|`vim.lsp.buf.rename(new_name?)`|重命名当前符号（全局生效）|`vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {desc = "重命名符号"})`|
|显示诊断信息|`vim.diagnostic.open_float()`|显示光标下的语法/语义错误|`vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, {desc = "显示诊断信息"})`|
|跳转到下一个诊断|`vim.diagnostic.goto_next()`|移动到下一个错误/警告位置|`vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, {desc = "上一个诊断"})`|
## 九、终端（Terminal）API

用于操作 Neovim 内置终端缓冲区。

|API 名称（中文）|语法|功能说明|示例|
|---|---|---|---|
|打开终端缓冲区|`vim.api.nvim_open_term(buf, opts?)`|创建终端进程并关联到缓冲区|`local buf = vim.api.nvim_create_buf(false, true)<br>local term = vim.api.nvim_open_term(buf, {})`|
|向终端发送数据|`vim.api.nvim_chan_send(chan, data)`|向终端通道发送命令/文本|`vim.api.nvim_chan_send(term, "ls\n") -- 执行 ls 命令`|
|打开终端窗口|`vim.fn.termopen(cmd, opts?)`|打开新终端窗口（Vimscript 兼容）|`vim.fn.termopen("bash", {cwd = vim.fn.getcwd()})`|
## 十、常用 Vimscript 兼容函数（vim.fn.*）

Lua 中可直接调用 Vimscript 核心函数，以下为高频使用的接口：

|函数名（中文）|语法|功能说明|示例|
|---|---|---|---|
|执行系统命令|`vim.fn.system(cmd)`|执行终端命令并返回输出|`local output = vim.fn.system("git status")`|
|创建目录|`vim.fn.mkdir(path, opts?)`|创建目录（支持递归创建）|`vim.fn.mkdir("~/nvim/config", "p") -- 递归创建`|
|文件是否存在|`vim.fn.filereadable(path)`|判断文件是否存在且可读（返回 1/0）|`if vim.fn.filereadable("test.lua") == 1 then ... end`|
|目录是否存在|`vim.fn.isdirectory(path)`|判断路径是否为目录（返回 1/0）|`if vim.fn.isdirectory("~/nvim") == 1 then ... end`|
|字符串匹配|`vim.fn.matchstr(str, pat)`|提取字符串中匹配模式的部分|`local res = vim.fn.matchstr("hello123", "\\d+") -- 输出 "123"`|
|获取缓冲区行数|`vim.fn.line("$")`|返回当前缓冲区的总行数|`local total_lines = vim.fn.line("$")`|
|复制到剪贴板|`vim.fn.setreg("+", text)`|将文本写入系统剪贴板寄存器|`vim.fn.setreg("+", "复制的内容")`|
## 附录：实用查询技巧

1. 查看 API 详情：`:help vim.api.nvim_buf_get_lines`（替换为具体 API 名）；

2. 查看 Lua 高层 API：`:help vim.keymap`、`:help vim.notify`；

3. 查看 Vimscript 函数：`:help fn-filereadable`（替换为具体函数名）；

4. 列出所有缓冲区：`:buffers`（或 `:ls`）；

5. 查看当前映射：`:map`（普通模式）、`:imap`（插入模式）。

本手册覆盖 Neovim 日常开发 90% 以上的核心 API，如需完整列表可参考官方文档：[https://neovim.io/doc/user/lua_api.html](https://neovim.io/doc/user/lua_api.html)。
> （注：文档部分内容可能由 AI 生成）