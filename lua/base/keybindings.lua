vim.g.mapleader = " "

vim.keymap.set("n", "<leader>fj", vim.cmd.Ex)
vim.keymap.set("n", "<leader>fs", "<cmd>:w<cr>")


vim.keymap.set("n", "<leader>qq", "<cmd>:q<cr>")
vim.keymap.set("n", "<leader><tab>", "<cmd>:b#<cr>")
vim.keymap.set("n", "<leader>bd", "<cmd>:bd<cr>")

vim.keymap.set("n", "<leader>w", "<C-w>")
vim.keymap.set("n", "<leader>wd", "<C-w>c")
vim.keymap.set("n", "<C-j>", "<cmd>:winc j<cr>")
vim.keymap.set("n", "<C-k>", "<cmd>:winc k<cr>")
vim.keymap.set("n", "<C-h>", "<cmd>:winc h<cr>")
vim.keymap.set("n", "<C-l>", "<cmd>:winc l<cr>")

local neogit = require('neogit')
local utils = require('telescope.utils')
vim.keymap.set("n", "<leader>gs", function()
  neogit.open({ cwd = utils.buffer_dir() })
end)

vim.keymap.set("i", "fd", "<Esc>")
