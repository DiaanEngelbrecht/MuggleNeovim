local telescope = require('telescope')

local sorters = require('telescope.sorters')

local custom_sorter = sorters.Sorter:new {
  scoring_function = function(entry, prompt, line)
    vim.print("---")
    vim.print("Line is " .. line)
    local number = tonumber(string.match(line, "%s*(%d+)%s*:"))
    vim.print("Buffer number: " .. vim.inspect(number))
    vim.print("List current state is below, length " .. _G.BufStack:getn())
    _G.BufStack:list()
    vim.print("Entry is listed " .. vim.inspect(_G.BufStack:get_index(number)))
    local score = (_G.BufStack:getn() - _G.BufStack:get_index(number)) * 10
    vim.print("Score " .. score)
    vim.print("---")
    return score
  end
}


telescope.setup {
  defaults = {
    file_ignore_patters = {
      "node_moduels",
      "target"
    },
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
    buffers = {
      sorter = custom_sorter
    }
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
telescope.load_extension("file_browser")
telescope.load_extension("project")

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
vim.keymap.set('n', 'g/', function() builtin.grep_string() end, {})
vim.keymap.set('n', '<leader>bb', function() builtin.buffers(ivy_theme) end, {})
vim.keymap.set('n', '<leader>pp', function() require 'telescope'.extensions.project.project(ivy_theme) end, {})
