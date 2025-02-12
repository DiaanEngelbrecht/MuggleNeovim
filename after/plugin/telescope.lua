local telescope = require('telescope')

local sorters = require('telescope.sorters')

-- Here I sort the output of the buffer window to look more like my stack
local bubble_stack_sorter = sorters.Sorter:new {
  scoring_function = function(entry, prompt, line)
    -- print("Line: ", vim.inspect(line))
    local number = tonumber(string.match(line, "%s*(%d+)%s*:"))
    local score = (_G.BufStack:getn() - _G.BufStack:get_index(number))
        * 10 + 10 + (line:lower():find(prompt:lower(), 1, true) or 100000)
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
      sorter = bubble_stack_sorter
    }
  },
  extensions = {
    file_browser = {
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

-- define here if you want to define something

local themes = require('telescope.themes')

local utils = require "telescope.utils"
local project_files = function()
  vim.fn.system('git rev-parse --is-inside-work-tree')
  if vim.v.shell_error == 0 then
    require "telescope.builtin".git_files({
      layout_strategy = 'bottom_pane',
      border = true,
      borderchars = {
        preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
        prompt = { "─", " ", " ", " ", "─", "─", " ", " " },
        results = { " " }
      },
      layout_config = {
        height = 0.4,
      },
    })
  else
    require "telescope.builtin".find_files({
      layout_strategy = 'bottom_pane',
      layout_config = {
        height = 0.4,
      },
      border = true,
      borderchars = {
        preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
        prompt = { "─", " ", " ", " ", "─", "─", " ", " " },
        results = { " " }
      },
    })
  end
end

local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>ff', function()
  require "telescope".extensions.file_browser.file_browser(themes.get_ivy({
    hidden = true,
    no_ignore = true,
    cwd = utils.buffer_dir(),
    layout_config = {
      height = 15,
    }
  }))
end, {})

vim.keymap.set('n', '<leader>pf', project_files, {})
vim.keymap.set('n', '<leader>/', function()
  builtin.live_grep(themes.get_ivy({ layout_config = { height = 15 } }))
end, {})
vim.keymap.set('n', 'g/', function() builtin.grep_string() end, {})
vim.keymap.set('n', '<leader>bb', function()
  builtin.buffers(
    themes.get_ivy(
      {
        layout_config = {
          height = 15
        },
        sorting_strategy = "ascending",
      }
    ))
end, {})
vim.keymap.set('n', '<leader>pp', function() require 'telescope'.extensions.project.project(ivy_theme) end, {})
