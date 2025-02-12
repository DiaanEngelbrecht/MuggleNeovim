require("lib.stack")

local tree_api = require("nvim-tree.api")
local tree_view = require("nvim-tree.view")

local function run_code()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local code = table.concat(lines, "\n")
  local filetype = vim.bo.filetype

  local interpreters = {
    python = "python",
    lua = "lua",
    sh = "bash",
    javascript = "node",
  }

  local interpreter = interpreters[filetype]
  if not interpreter then
    vim.notify("No interpreter found for filetype: " .. filetype, vim.log.levels.ERROR)
    return
  end

  local temp_file = "/tmp/scratch_code." .. filetype
  local file = io.open(temp_file, "w")
  file:write(code)
  file:close()

  local result = vim.fn.system(interpreter .. " " .. temp_file)

  vim.cmd("new")
  vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(result, "\n"))
end

vim.api.nvim_create_user_command("Scratch", function()
  local scratch_name = "ScratchBuffer"

  local function get_basename(bufname)
    return bufname:match("^.+/(.+)$") or bufname -- Extract the basename, or return as-is if no path
  end

  -- Check if a buffer named ScratchBuffer already exists
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if get_basename(vim.api.nvim_buf_get_name(buf)) == scratch_name then
      -- Navigate to the existing ScratchBuffer
      vim.api.nvim_set_current_buf(buf)
      return
    end
  end
  -- Create a new buffer
  vim.cmd("enew")

  -- Set the buffer to be a scratch buffer
  vim.bo.buftype = "nofile"
  vim.bo.swapfile = false

  -- Set the buffer name
  vim.api.nvim_buf_set_name(0, scratch_name)
end, {})

vim.keymap.set("n", "<leader>rc", run_code, { noremap = true, silent = true })
vim.keymap.set("n", "<leader>bs", "<cmd>:Scratch<cr>")

vim.keymap.set("n", "<leader>fj", vim.cmd.Ex)
vim.keymap.set("n", "<leader>fs", "<cmd>:w<cr>")

-- Shortcuts to very quickly edit 
vim.keymap.set("n", "<leader>eb", "<cmd>:e ~/.zshrc<cr>")
vim.keymap.set("n", "<leader>es", "<cmd>:e ~/.ssh/config<cr>")
vim.keymap.set("n", "<leader>eh", "<cmd>:e ~/.ssh/known_hosts<cr>")

vim.keymap.set("n", "<leader>ll", "<cmd>:LspInfo<cr>")
vim.keymap.set("n", "<leader>lf", "<cmd>:Format<cr>")
vim.keymap.set("n", "<leader>ls", "<cmd>:Mason<cr>")

vim.keymap.set("n", "<leader>qq", function()
  if tree_view.is_visible() then
    tree_api.tree.close()
  end
  vim.cmd(":q")
end)


vim.keymap.set("n", "<leader>ld", function()
  local linters = require("lint").get_running()
  vim.print("Active linters" .. table.concat(linters, ", "))
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

_G.BufStack = BubbleStack:Create()

vim.keymap.set("n", "<leader><tab>", function()
  local len = _G.BufStack:getn()
  if len > 1 then
    -- vim.print("Buffer exists: " .. vim.fn.bufexists(_G.BufStack._et[len - 1]))
    if vim.fn.bufexists(_G.BufStack._et[len - 1]) == 1 then
      vim.api.nvim_set_current_buf(_G.BufStack._et[len - 1])
    else
      _G.BufStack:remove(_G.BufStack._et[len - 1])
      vim.print("Deleted phantom buffer")
      len = _G.BufStack:getn()
      if len > 1 then
        -- Here I'm assuming I won't have more than one phantom buffer in a row
        vim.api.nvim_set_current_buf(_G.BufStack._et[len - 1])
      end
    end
  end
end, { desc = "Switch to Other Buffer" })

vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
  callback = function(args)
    -- vim.print("Entering buffer number " .. args.buf .. " buffer type is " .. vim.bo[args.buf].buftype)
    if vim.fn.buflisted(args.buf) == 1 and vim.bo[args.buf].buftype == "" then
      -- vim.print("Pushing buffer")
      _G.BufStack:push_bubble(args.buf)
    end
  end,
})

vim.api.nvim_create_autocmd({ "BufDelete", "BufWipeout" }, {
  callback = function(args)
    if vim.fn.buflisted(args.buf) == 1 and vim.bo[args.buf].buftype == "" then
      -- vim.print("Leaving buffer: " .. vim.inspect(args.buf))
      _G.BufStack:remove(args.buf)
    end
  end,
})

vim.keymap.set("n", "<leader>bd", function()
  local current_buff = vim.api.nvim_get_current_buf()
  if vim.fn.buflisted(current_buff) == 1 and vim.bo[current_buff].buftype == "" then
    local len = _G.BufStack:getn()
    if len > 1 then
      vim.api.nvim_set_current_buf(_G.BufStack._et[len - 1])
    end
  end
  vim.cmd(":BufDel " .. current_buff)
end)

vim.keymap.set("n", "<leader>t", function()
    vim.cmd(":ToggleTerm")
end)

vim.keymap.set("t", "<C-t>", "<cmd>:ToggleTerm<cr>")
vim.api.nvim_set_keymap("t", "<C-k>", [[<C-\><C-n><C-w>k]], { noremap = true, silent = true })
vim.api.nvim_set_keymap("t", "fd", [[<C-\><C-n>]], { noremap = true, silent = true })

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
