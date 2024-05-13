require("lib.stack")

local tree_api = require("nvim-tree.api")
local tree_view = require("nvim-tree.view")

vim.keymap.set("n", "<leader>fj", vim.cmd.Ex)
vim.keymap.set("n", "<leader>fs", "<cmd>:w<cr>")

vim.keymap.set("n", "<leader>ll", "<cmd>:LspInfo<cr>")
vim.keymap.set("n", "<leader>lf", function()
  vim.lsp.buf.format()
end)
vim.keymap.set("n", "<leader>ls", "<cmd>:Mason<cr>")

vim.keymap.set("n", "<leader>qq", function()
  if tree_view.is_visible() then
    tree_api.tree.close()
  end
  vim.cmd(":q")
end)

vim.keymap.set("n", "<leader>cr", "<cmd>%s/\\r//g<cr>")
vim.keymap.set("n", "<leader>c/", "<cmd>let @/ = \"\"<cr>")

vim.keymap.set("v", ">", ">gv")
vim.keymap.set("v", "<", "<gv")

vim.keymap.set("n", "<leader><C-o>", function()
  local jl = vim.fn.getjumplist()
  local currentJump = jl[2]
  for i = currentJump, 0, -1 do
    if jl[1][i]["bufnr"] ~= vim.fn.bufnr('%') then
      vim.cmd([[execute "normal! ]] .. (currentJump - i + 1) .. [[\<c-o>"]])
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
end, { desc = "Switch to Other Buffer" })

vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
  callback = function(args)
    -- vim.print("Entering buffer number " .. args.buf .. " buffer type is " .. vim.bo[args.buf].buftype)
    if vim.fn.buflisted(args.buf) == 1 and vim.bo[args.buf].buftype == "" then
      -- vim.print("Pushing buffer")
      BufStack:push_bubble(args.buf)
    end
  end,
})

vim.api.nvim_create_autocmd({ "BufDelete", "BufWipeout" }, {
  callback = function(args)
    if vim.fn.buflisted(args.buf) == 1 and vim.bo[args.buf].buftype == "" then
      -- vim.print("Leaving buffer: " .. vim.inspect(args.buf))
      BufStack:remove(args.buf)
    end
  end,
})

vim.keymap.set("n", "<leader>bd", function()
  local current_buff = vim.api.nvim_get_current_buf()
  if vim.fn.buflisted(current_buff) == 1 and vim.bo[current_buff].buftype == "" then
    local len = BufStack:getn()
    if len > 1 then
      vim.api.nvim_set_current_buf(BufStack._et[len - 1])
    end
  end
  vim.cmd(":BufDel " .. current_buff)
end)

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
  require 'agitator'.git_blame_toggle {
    sidebar_width = 35,
    formatter = function(r)
      return r.date.year ..
          "/" .. r.date.month .. "/" .. r.date.day .. ":" .. r.author:sub(0, 5) .. " - " .. r.summary;
    end }
end)
vim.keymap.set("n", "<leader>gt", function()
  require('agitator').git_time_machine({ use_current_win = true })
end)

vim.keymap.set("i", "fd", "<Esc>")
