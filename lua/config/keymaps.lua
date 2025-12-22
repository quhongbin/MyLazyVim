-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = LazyVim.safe_keymap_set
map("i", "jk", "<Esc>")
map("v", "jk", "<Esc>")
map("n", "<leader>qa", "<Cmd>wqall<CR>", { desc = "write and quit all files" })
vim.keymap.set("n", "<C-m>", ":w")
