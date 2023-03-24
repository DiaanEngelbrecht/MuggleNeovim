
local lib = require("nvim-tree.lib")

local config = {
    view = {
        mappings = {
            custom_only = false,
            list = {
                { key = "l", action = "cd"},
                { key = "h", action = "dir_up", action_cb = lib.dir_up },
            }
        },
    },
    actions = {
        open_file = {
            quit_on_open = false
        }
    }
}

local view = require("nvim-tree.view")

vim.keymap.set("n", "<leader>ft", function ()
  if view.is_visible() then
    if view.get_winnr() == vim.api.nvim_get_current_win() then
      -- do nothing
      -- maybe close here? but I'd rather learn to use q
    else
      vim.cmd("NvimTreeFindFile")
      view.focus()
    end
  else
      vim.cmd("NvimTreeFindFile")
      view.focus()
  end
end)

require('nvim-tree').setup(config)
