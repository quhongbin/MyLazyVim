-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local set = vim.opt
set.tabstop = 2
set.autoindent = true


-- 共享剪切板
set.clipboard = "unnamedplus"


-- 搜索
set.ignorecase = true
set.smartcase = true


--外观
set.termguicolors = true

set.signcolumn = "yes"

local keymap = vim.keymap
-- 映射按键
keymap.set("i", "jk", "<Esc>")
keymap.set("v", "jk", "<Esc>")
-- keymap.set("n", "<Space>", ":")
--视觉模式移动区块
keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv")
keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv")
keymap.set("v", "<A-h>", "<gv")
keymap.set("v", "<A-l>", ">gv")
