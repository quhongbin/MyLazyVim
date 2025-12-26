return {
  "L3MON4D3/LuaSnip",
  version = "v2.*", -- 锁定稳定版本，避免自动更新出问题
  build = "make install_jsregexp", -- 可选：启用 js 正则支持（处理复杂片段）
  dependencies = {
    -- 可选：搭配 friendly-snippets 获得预设片段（比如常见语言的默认片段）
    "rafamadriz/friendly-snippets",
    config = function()
      -- 加载 friendly-snippets 的所有预设片段
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },
  opts = {
    -- 基础行为配置（核心，可按需修改）
    history = true, -- 保留片段历史，按 <C-p>/<C-n> 可切换历史选择
    updateevents = "TextChanged,TextChangedI", -- 输入时实时更新片段
    enable_autosnippets = true, -- 启用自动触发的片段（比如输入 `func` 自动弹出函数模板）
    delete_check_events = "TextChanged", -- 删除时检查片段有效性
    -- 自定义触发/跳转键（新手推荐保留默认，后续可改）
    -- 注意：LazyVim 已绑定 <Tab> 为补全触发键，无需重复配置
    -- 片段内跳转：<Tab> 下一个位置，<S-Tab> 上一个位置（默认映射）
    ext_opts = {
      [require("luasnip.util.types").choiceNode] = {
        active = {
          virt_text = { { "󰞷 选择片段", "Comment" } }, -- 选择片段时的提示文字
        },
      },
    },
  },
  config = function(_, opts)
    -- 应用基础配置
    require("luasnip").setup(opts)

    -- 方式2：从外部文件加载片段（适合大量片段，后续扩展用）
    -- 比如新建 ~/.config/nvim/lua/snippets/ 目录，按文件类型存放片段
    require("luasnip.loaders.from_lua").lazy_load({ paths = "~/.config/nvim/lua/snippets/" })
  end,
}
