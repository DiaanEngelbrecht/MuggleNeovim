require('telescope').setup {
  defaults = {
    -- Default configuration for telescope goes here:
    -- config_key = value,
    mappings = {
      i = {
        -- map actions.which_key to <C-h> (default: <C-/>)
        -- actions.which_key shows the mappings for your picker,
        -- e.g. git_{create, delete, ...}_branch for the git_branches picker
        ["<C-j>"] = "move_selection_next",
        ["<C-k>"] = "move_selection_previous",
        ["<C-g>"] = "close",
      },
      ["n"] = {
        ["<C-g>"] = "close",
        ["q"] = "close",
      }
    },
    preview = true
  },
  pickers = {
    -- Default configuration for builtin pickers goes here:
    -- picker_name = {
    --   picker_config_key = value,
    --   ...
    -- }
    -- Now the picker_config_key will be applied every time you call this
    -- builtin picker
  },
  extensions = {
    file_browser = {
      --theme = "ivy",
      mappings = {
        ["i"] = {
          ["<C-h>"] = require "telescope".extensions.file_browser.actions.goto_parent_dir,
          ["<C-l>"] = "select_default",
          ["<tab>"] = "select_default",
        }
      }
    }
  }
}
require("telescope").load_extension("file_browser")
require("telescope").load_extension("project")

local ivy_theme = require('telescope.themes').get_ivy({
  hidden = true,
  layout_config = {
    height = 15,
  }
})

local utils = require "telescope.utils"
local project_files = function()
  local opts = ivy_theme -- define here if you want to define something
  opts["cwd"] = utils.buffer_dir()
  vim.fn.system('git rev-parse --is-inside-work-tree')
  if vim.v.shell_error == 0 then
    require "telescope.builtin".git_files(opts)
  else
    require "telescope.builtin".find_files(opts)
  end
end

local builtin = require('telescope.builtin')

local themes = require('telescope.themes')
vim.keymap.set('n', '<leader>ff', function()
  require "telescope".extensions.file_browser.file_browser(themes.get_ivy({
    hidden = true,
    cwd = utils.buffer_dir(),
    layout_config = {
      height = 15,
    }
  }))
end, {})

vim.keymap.set('n', '<leader>pf', project_files, {})
vim.keymap.set('n', '<leader>/', function() builtin.live_grep(ivy_theme) end, {})
vim.keymap.set('n', '<leader>bb', function() builtin.buffers(ivy_theme) end, {})
vim.keymap.set('n', '<leader>pp', function() require 'telescope'.extensions.project.project(ivy_theme) end, {})
