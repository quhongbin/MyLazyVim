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
    },
  },
  --{
  --  "3rd/image.nvim",
  --  opts = {},
  --},
}
