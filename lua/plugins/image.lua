return {
  {
    "vhyrro/luarocks.nvim",
    priority = 1001, -- this plugin needs to run before anything else
    opts = {
      rocks = { "magick" },
    },
  },
  {
    "3rd/image.nvim",
    dependencies = { "luarocks.nvim" },
    opts = {
      processor = "magick_rock",
      -- backend = "wezterm",
      max_width = 30,
      max_height = 30,
      -- window_overlap_clear_enabled = true,
    },
  },
  --{
  --  "3rd/image.nvim",
  --  opts = {},
  --},
}
