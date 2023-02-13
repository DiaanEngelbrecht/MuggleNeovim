vim.g.mapleader = " "

vim.keymap.set("n", "<leader>fj", vim.cmd.Ex)
vim.keymap.set("n", "<leader>ft", "<cmd>:NvimTreeFocus<cr>")
vim.keymap.set("n", "<leader>fs", "<cmd>:w<cr>")

vim.keymap.set("n", "<leader>qq", "<cmd>:q<cr>")
vim.keymap.set("n", "<leader><tab>", "<cmd>:b#<cr>")
vim.keymap.set("n", "<leader>bd", "<cmd>:bwipeout<cr>")
vim.keymap.set("n", "f", "<cmd>:bn<cr>")
vim.keymap.set("n", "s", "<cmd>:bp<cr>")

vim.keymap.set("n", "<leader>tn", "<cmd>:FloatermNew --height=0.9 --width=0.9<cr>")
vim.keymap.set("n", "<leader>tt", "<cmd>:FloatermToggle<cr>")

vim.keymap.set("t", "<C-t>", "<cmd>:FloatermNew --height=0.9 --width=0.9<cr>")
vim.keymap.set("t", "<C-k>", "<cmd>:FloatermToggle<cr>")
vim.keymap.set("t", "<C-j>", "<cmd>:FloatermToggle<cr>")
vim.keymap.set("t", "<C-l>", "<cmd>:FloatermNext<cr>")
vim.keymap.set("t", "<C-h>", "<cmd>:FloatermPrev<cr>")

vim.keymap.set("n", "<leader>w", "<C-w>")
vim.keymap.set("n", "<leader>wd", "<C-w>c")
vim.keymap.set("n", "<C-j>", "<cmd>:winc j<cr>")
vim.keymap.set("n", "<C-k>", "<cmd>:winc k<cr>")
vim.keymap.set("n", "<C-h>", "<cmd>:winc h<cr>")
vim.keymap.set("n", "<C-l>", "<cmd>:winc l<cr>")
vim.keymap.set("n", "<leader>fc", "<cmd>:cd %:h<cr>")

local neogit = require('neogit')
local utils = require('telescope.utils')
vim.keymap.set("n", "<leader>gs", function()
  neogit.open({ cwd = utils.buffer_dir() })
end)

vim.keymap.set("i", "fd", "<Esc>")
