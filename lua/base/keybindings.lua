require("lib.stack")

vim.g.mapleader = " "

vim.keymap.set("n", "<leader>fj", vim.cmd.Ex)
vim.keymap.set("n", "<leader>fs", "<cmd>:w<cr>")

vim.keymap.set("n", "<leader>ll", "<cmd>:LspInfo<cr>")
vim.keymap.set("n", "<leader>lf", function()
  vim.lsp.buf.format()
end)
vim.keymap.set("n", "<leader>ls", "<cmd>:Mason<cr>")

vim.keymap.set("n", "<leader>qq", "<cmd>:q<cr>")

vim.keymap.set("n", "<leader><C-o>", function()
 local jl = vim.fn.getjumplist()
  local currentJump = jl[2]
  for i = currentJump, 0, -1 do
    if jl[1][i]["bufnr"] ~= vim.fn.bufnr('%') then
      vim.cmd([[execute "normal! ]]..(currentJump - i + 1)..[[\<c-o>"]])
      break
    end
  end
end)

BufStack = BubbleStack:Create()

vim.keymap.set("n", "<leader><tab>", function()
  local len = BufStack:getn()
  if len > 1 then
    vim.api.nvim_set_current_buf(BufStack._et[len - 1])
  end
end)

vim.api.nvim_create_autocmd({"BufWinEnter"}, {
  callback = function(args)
    if vim.fn.buflisted(args.buf) == 1 then
      BufStack:push_bubble(args.buf)
    end
  end,
})

vim.api.nvim_create_autocmd({"BufDelete", "BufWipeout"}, {
  callback = function(args)
    BufStack:remove(args.buf)
  end,
})

vim.keymap.set("n", "<leader>bd", "<cmd>:BufDel<cr>")

vim.keymap.set("n", "<leader>t", function()
  local current_buff = vim.fn['floaterm#buflist#curr']()
  if current_buff == -1 then
    vim.cmd(":FloatermNew --height=0.9 --width=0.9")
  else
    vim.cmd(":FloatermToggle")
  end
end)

vim.keymap.set("t", "<C-t>", "<cmd>:FloatermNew --height=0.9 --width=0.9<cr>")
vim.keymap.set("t", "<C-k>", "<cmd>:FloatermToggle<cr>")
vim.keymap.set("t", "<C-j>", "<cmd>:FloatermToggle<cr>")
vim.keymap.set("t", "<C-l>", "<cmd>:FloatermNext<cr>")
vim.keymap.set("t", "<C-h>", "<cmd>:FloatermPrev<cr>")

vim.keymap.set("n", "<leader>w", "<C-w>")
vim.keymap.set("n", "<leader>wd", "<C-w>c")
vim.keymap.set("n", "<leader>fc", "<cmd>:cd %:h<cr>")

local neogit = require('neogit')
local utils = require('telescope.utils')
vim.keymap.set("n", "<leader>gs", function()
  neogit.open({ cwd = utils.buffer_dir() })
end)
vim.keymap.set("n", "<leader>gb", function()
  -- require('agitator').git_blame()
  require'agitator'.git_blame_toggle{
    sidebar_width = 35,
    formatter=function(r) return r.date.year .. "/" .. r.date.month .. "/" .. r.date.day .. ":".. r.author:sub(0,5) .. " - " .. r.summary; end}
end)
vim.keymap.set("n", "<leader>gt", function()
  require('agitator').git_time_machine({use_current_win= true})
end)

vim.keymap.set("i", "fd", "<Esc>")
