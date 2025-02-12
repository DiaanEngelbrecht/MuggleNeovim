-- Learn the keybindings, see :help lsp-zero-keybindings
-- Learn to configure LSP servers, see :help lsp-zero-api-showcase
require("mason").setup()

local lsp = require('lsp-zero')
lsp.preset('recommended')

-- (Optional) Configure lua language server for neovim
lsp.nvim_workspace()

lsp.ensure_installed({ 'rust_analyzer', })

lsp.configure('rust_analyzer', {
  settings = {
    ["rust-analyzer"] = {
      checkOnSave = {
        command = "clippy"
      },
    }
  }
})

local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
  ['<C-k>'] = cmp.mapping.select_prev_item(cmp_select),
  ['<C-j>'] = cmp.mapping.select_next_item(cmp_select),
  ['<enter>'] = cmp.mapping.confirm({ select = true }),
  ["<tab>"] = cmp.mapping.complete(),
})

lsp.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  lsp.default_keymaps({ buffer = bufnr })
end)

lsp.setup_nvim_cmp({
  mapping = cmp_mappings
})

lsp.setup_servers({ 'dartls', force = true })

lsp.setup()

vim.keymap.set("n", "<leader>la", function()
  vim.lsp.buf.code_action()
end)

require("formatter").setup {
  -- Enable or disable logging
  logging = true,
  -- Set the log level
  log_level = vim.log.levels.WARN,
  -- All formatter configurations are opt-in
  filetype = {
    -- Formatter configurations for filetype "lua" go here
    -- and will be executed in order
    typescript = {
      require("formatter.filetypes.typescript").prettier,
    },
    json = {
      require("formatter.filetypes.json").prettier,
    },
    elixir = {
      require("formatter.filetypes.elixir").mixformat,
    },
    python = {
      require("formatter.filetypes.python").autopep8,
    },
    rust = {
      require("formatter.filetypes.rust").rustfmt,
    },
    svelte = {
      require("formatter.filetypes.svelte").prettier,
    },
    toml = {
      require("formatter.filetypes.toml").taplo,
    },

    -- Use the special "*" filetype for defining formatter configurations on
    -- any filetype
    ["*"] = {
      require("formatter.filetypes.any").remove_trailing_whitespace,
    }
  }
}
