# Neovim Autocmd 事件全列表

## 说明

Autocmd（自动命令）是Neovim中用于在特定事件触发时自动执行命令的核心机制。以下按功能分类列举**所有官方支持的Autocmd事件**，并标注触发时机，便于后续查询和使用。

## 一、启动与退出相关事件

|事件名|触发时机|
|---|---|
|VimEnter|Neovim 完全启动后（所有配置、插件加载完成，界面初始化完毕）|
|VimLeave|Neovim 退出前（所有窗口尚未关闭，可执行清理操作）|
|VimLeavePre|Neovim 退出早期阶段（比 VimLeave 更早，窗口仍保留）|
|VimResized|Neovim 窗口/终端大小被调整时|
|SessionLoadPost|会话（session）加载完成后|
|SessionSavePre|会话保存前（可修改会话内容）|
## 二、缓冲区（Buffer）核心事件

缓冲区是Autocmd最常用的关联对象，涵盖文件读写、缓冲区生命周期等场景。

|事件名|触发时机|
|---|---|
|BufAdd|缓冲区被添加到缓冲区列表时（即使未加载文件）|
|BufCreate|新建缓冲区时（如 `:new`、编辑新文件）|
|BufDelete|缓冲区从列表中删除时（仍可能保留在内存）|
|BufEnter|进入缓冲区（成为当前缓冲区）时（窗口切换/打开新缓冲区）|
|BufFilePost|缓冲区关联的文件被重命名/移动后|
|BufFilePre|缓冲区关联的文件即将被重命名/移动前|
|BufHidden|缓冲区从当前窗口隐藏时（切换到其他缓冲区）|
|BufLeave|离开当前缓冲区（切换到其他缓冲区）时|
|BufModifiedSet|缓冲区的修改状态（modified flag）被设置/清除时|
|BufNew|创建空缓冲区时（未关联任何文件）|
|BufNewFile|编辑不存在的文件时（首次写入前触发）|
|BufRead|开始读取文件到缓冲区时（`:edit`/`:split` 等操作）|
|BufReadCmd|替代默认文件读取逻辑（自定义读取时触发）|
|BufReadPost|文件读取到缓冲区完成后（常用作初始化）|
|BufReadPre|文件读取到缓冲区前（可拦截读取）|
|BufUnload|缓冲区被卸载（内存移除，仍在缓冲区列表）|
|BufWinEnter|缓冲区进入窗口（窗口显示该缓冲区）时|
|BufWinLeave|缓冲区离开窗口（窗口不再显示该缓冲区）时|
|BufWrite|开始将缓冲区写入文件时|
|BufWriteCmd|替代默认文件写入逻辑（自定义写入时触发）|
|BufWritePost|缓冲区写入文件完成后（常用作保存后操作）|
|BufWritePre|缓冲区写入文件前（常用作保存前格式化/检查）|
|BufWipeout|缓冲区被彻底清除（列表+内存中移除）|
|FileAppendCmd|替代默认文件追加逻辑|
|FileAppendPost|文件追加内容完成后|
|FileAppendPre|文件追加内容前|
|FileChangedShell|检测到文件在外部被修改（与缓冲区内容不一致）|
|FileChangedShellPost|处理完 FileChangedShell 后的后续事件|
|FileReadCmd|全局级文件读取逻辑替代（比 BufReadCmd 更通用）|
|FileReadPost|全局级文件读取完成后（比 BufReadPost 早）|
|FileReadPre|全局级文件读取前（比 BufReadPre 早）|
|FileWriteCmd|全局级文件写入逻辑替代（比 BufWriteCmd 更通用）|
|FileWritePost|全局级文件写入完成后（比 BufWritePost 早）|
|FileWritePre|全局级文件写入前（比 BufWritePre 早）|
|SwapExists|检测到交换文件（swap file）存在时（可选择恢复/忽略）|
## 三、窗口（Window）相关事件

|事件名|触发时机|
|---|---|
|WinEnter|进入窗口（成为活动窗口）时|
|WinLeave|离开窗口（切换到其他窗口）时|
|WinNew|新建窗口时（如 `:split`/`:vsplit`）|
|WinClosed|窗口被关闭时（Neovim 0.5+ 新增）|
|WinScrolled|窗口内容滚动时（鼠标滚轮、`Ctrl+D`/`Ctrl+U`、滚动条等）|
## 四、编辑与文本操作事件

|事件名|触发时机|
|---|---|
|InsertEnter|进入插入模式时|
|InsertLeave|离开插入模式时（切换到普通/可视/命令行模式）|
|InsertChange|插入模式内的子模式变化（如插入→替换模式）|
|InsertCharPre|插入字符前（可拦截/修改输入字符）|
|TextChanged|缓冲区文本被修改后（普通/插入模式均触发）|
|TextChangedI|插入模式下文本修改后（每次输入字符触发）|
|TextChangedP|命令行预览文本修改后|
|TextYankPost|文本被复制到寄存器后（常用作高亮复制内容）|
|QuickFixCmdPre|执行快速修复命令前（`:make`/`:grep`/`:copen` 等）|
|QuickFixCmdPost|执行快速修复命令后|
|CmdlineEnter|进入命令行模式（输入 `:`/`/`/`?` 等）时|
|CmdlineLeave|离开命令行模式（执行/取消命令）时|
|CmdlineChanged|命令行内容被修改时|
|CmdwinEnter|进入命令行窗口（`:cw`）时|
|CmdwinLeave|离开命令行窗口时|
|CompleteChanged|自动补全内容变化时|
|CompleteDone|自动补全完成（选择/取消）后|
## 五、文件类型与语法相关事件

|事件名|触发时机|
|---|---|
|FileType|缓冲区文件类型（filetype）被设置时（BufReadPost/BufNewFile 后触发）|
|Syntax|语法高亮被设置/切换时|
|ColorScheme|配色方案（colorscheme）加载完成时|
|FileEncoding|缓冲区文件编码被设置时|
|FileFormat|缓冲区换行格式（unix/dos/mac）被设置时|
## 六、终端（Terminal）相关事件

|事件名|触发时机|
|---|---|
|TermOpen|打开终端缓冲区（`:terminal`）时|
|TermClose|终端缓冲区对应的进程退出时|
|TermEnter|进入终端交互模式（终端缓冲区按 `i`）时|
|TermLeave|离开终端交互模式（终端缓冲区按 `<Esc>`）时|
|TermResponse|终端接收到响应数据时（Neovim 0.6+）|
## 七、折叠（Fold）相关事件

|事件名|触发时机|
|---|---|
|FoldOpen|折叠被展开时|
|FoldClose|折叠被关闭时|
## 八、拼写检查相关事件

|事件名|触发时机|
|---|---|
|SpellFileMissing|拼写检查字典文件缺失时|
|SpellCheck|拼写检查执行时（Neovim 0.7+）|
## 九、用户自定义事件

|事件名|触发时机|
|---|---|
|User|自定义事件，需通过 `:doautocmd User <事件名>` 手动触发|
## 十、其他通用事件

|事件名|触发时机|
|---|---|
|CursorMoved|普通模式下光标移动时|
|CursorMovedI|插入模式下光标移动时|
|CursorHold|普通模式光标静止指定时间后（默认 1000ms，可通过 `updatetime` 修改）|
|CursorHoldI|插入模式光标静止指定时间后|
|FocusGained|Neovim 窗口获得焦点时（终端从后台切回）|
|FocusLost|Neovim 窗口失去焦点时（终端切到后台）|
|OptionSet|Neovim 选项被修改时（如 `:set number`/`:set tabstop=4`）|
|RemoteReply|接收到远程 RPC 回复时|
|Signal|接收到系统信号时（如 SIGUSR1、SIGWINCH）|
|SourcePre|执行 `:source` 加载脚本前|
|SourcePost|执行 `:source` 加载脚本后|
|SourceCmd|替代默认 `:source` 逻辑时|
|Timer|定时器到期时（`vim.fn.timer_start()` 创建的定时器）|
|UIEnter|UI 界面初始化完成后（Neovim 0.5+，GUI/终端 UI 加载完毕）|
|UILeave|UI 界面关闭前（Neovim 0.5+）|
|UserGettingBored|彩蛋事件：用户长时间无操作（仅娱乐，无实际功能）|
## 实用补充

### 1. 事件执行顺序（常用场景）

- 文件读取：`BufReadPre` → `BufRead` → `BufReadPost` → `FileType` → `Syntax`

- 文件保存：`BufWritePre` → `BufWrite` → `BufWritePost`

- 插入模式：`InsertEnter` → `InsertCharPre` → `TextChangedI` → `InsertLeave` → `TextChanged`

### 2. 事件绑定示例

```Lua

```

### 3. 官方文档查询

- 查看所有事件：`:help autocmd-events`

- 查看单个事件详情：`:help <事件名>`（如 `:help BufWritePost`）

- 查看事件属性：`:help autocmd-patterns`（缓冲区/窗口范围、匹配规则）

### 4. 版本兼容性

- `WinClosed`/`UIEnter`/`UILeave` 需 Neovim 0.5+

- `TermResponse` 需 Neovim 0.6+

- `SpellCheck` 需 Neovim 0.7+

该列表覆盖 Neovim 稳定版（0.9+）所有官方 Autocmd 事件，可直接保存为 Markdown 文件用于日常查询。
> （注：文档部分内容可能由 AI 生成）
