local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "       -- Make sure to set `mapleader` before lazy so your mappings are correct
vim.g.maplocalleader = "\\" -- Same for `maplocalleader`

require("lazy").setup({
  { "navarasu/onedark.nvim",     lazy = false,  priority = 1000 },
  { 'akinsho/git-conflict.nvim', version = "*", config = true },
  "ojroques/nvim-bufdel",
  "xiyaowong/transparent.nvim",
  "christoomey/vim-tmux-navigator",
  "lukas-reineke/indent-blankline.nvim",
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.6',
    dependencies = { 'nvim-lua/plenary.nvim' }
  },
  "nvim-telescope/telescope-file-browser.nvim",
  "nvim-telescope/telescope-project.nvim",
  { 'akinsho/toggleterm.nvim', version = "*", opts = { --[[ things you want to change go here]] } },
  "numToStr/Comment.nvim",
  "nvim-treesitter/nvim-treesitter",
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v1.x',
    dependencies = {
      -- LSP Support
      { 'neovim/nvim-lspconfig' },
      { 'williamboman/mason.nvim' },
      { 'williamboman/mason-lspconfig.nvim' },

      -- Autocompletion
      { 'hrsh7th/nvim-cmp' },
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-path' },
      { 'saadparwaiz1/cmp_luasnip' },
      { 'hrsh7th/cmp-nvim-lua' },

      -- Snippets
      { 'L3MON4D3/LuaSnip' },
      { 'rafamadriz/friendly-snippets' },
    }
  },
  {
    "mfussenegger/nvim-lint",
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('lint').linters_by_ft = {
        typescript = { 'eslint' },
        elixir = { 'credo' },
      }

      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        callback = function()
          require("lint").try_lint()
        end,
      })
    end
  },
  'mhartington/formatter.nvim',
  {
    'glepnir/dashboard-nvim',
    event = 'VimEnter',
    config = function()
      require('dashboard').setup {
        -- config
        theme = 'hyper',
        config = require('base.dashboard').config,
      }
    end,
    dependencies = { 'nvim-tree/nvim-web-devicons' }
  },
  "rcarriga/nvim-notify",
  "stevearc/dressing.nvim",
  { "kevinhwang91/nvim-bqf",   ft = 'qf' },
  {
    "NeogitOrg/neogit",
    lazy = false,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'sindrets/diffview.nvim',
      "nvim-telescope/telescope.nvim"
    },
    config = true
  },
  { "echasnovski/mini.nvim", branch = 'stable' },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { 'kyazdani42/nvim-web-devicons', opt = true }
  },
  {
    "folke/edgy.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-tree/nvim-tree.lua", -- optional, for file explorer integration
      "akinsho/toggleterm.nvim", -- optional, for terminal integration
    },
    init = function()
      vim.opt.laststatus = 3
      vim.opt.splitkeep = "screen"
    end,
    opts = {
      bottom = {
        -- toggleterm / lazyterm at the bottom with a height of 40% of the screen
        {
          ft = "toggleterm",
          size = { height = 0.3 },
          title = "Terminal"
        },
        "Trouble",
        { ft = "qf",            title = "QuickFix" },
        {
          ft = "help",
          size = { height = 20 },
          -- only show help buffers
          filter = function(buf)
            return vim.bo[buf].buftype == "help"
          end,
        },
        { ft = "spectre_panel", size = { height = 0.4 } },
      },
      left = {
        -- Neo-tree filesystem always takes half the screen height
        {
          title = "Files",
          ft = "NvimTree",
          size = { height = 0.5 },
        },
      },
      right = {
        -- Edgy doesn't capture all the windows of avante really nicely, so commenting out for now
        -- Avante
        -- {
        --   title = "AI",
        --   ft = "AvanteSelectedFiles",
        --   size = { height = 0.1, width = 0.3 },
        -- },
        -- {
        --   title = "AI",
        --   ft = "Avante",
        --   size = { height = 0.7, width = 0.3 },
        --   open = function ()
        --     require("edgy").close("left")
        --   end
        -- },
        -- {
        --   title = "Chat",
        --   ft = "AvanteInput",
        --   size = { height = 0.2, width = 0.3 },
        -- },
      },
    },
  },
  "emmanueltouzery/agitator.nvim",
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
  },
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    build = "make", -- This is Optional, only if you want to use tiktoken_core to calculate tokens count
    opts = {
      -- add any opts here
      provider = "claude",
      vendors = {
        ---@type AvanteProvider
        codestral = {
          api_key_name = '',
          endpoint = "127.0.0.1:1234/v1",
          model = "lmstudio-community/Codestral-22B-v0.1-GGUF/Codestral-22B-v0.1-Q2_K.gguf",
          parse_curl_args = function(opts, code_opts)
            return {
              url = opts.endpoint .. "/chat/completions",
              headers = {
                ["Accept"] = "application/json",
                ["Content-Type"] = "application/json",
              },
              body = {
                model = opts.model,
                messages = require("avante.providers").copilot.parse_message(code_opts), -- you can make your own message, but this is very advanced
                max_tokens = 8192,
                stream = true,
              },
            }
          end,
          parse_response_data = function(data_stream, event_state, opts)
            require("avante.providers").openai.parse_response(data_stream, event_state, opts)
          end,
        },
        ---@type AvanteProvider
        local_llama = {
          api_key_name = '',
          endpoint = "127.0.0.1:1234/v1",
          model = "lmstudio-community/Meta-Llama-3-8B-Instruct-GGUF/Meta-Llama-3-8B-Instruct-Q4_K_M.gguf",
          parse_curl_args = function(opts, code_opts)
            return {
              url = opts.endpoint .. "/chat/completions",
              headers = {
                ["Accept"] = "application/json",
                ["Content-Type"] = "application/json",
              },
              body = {
                model = opts.model,
                messages = require("avante.providers").copilot.parse_message(code_opts), -- you can make your own message, but this is very advanced
                max_tokens = 8192,
                stream = true,
              },
            }
          end,
          parse_response_data = function(data_stream, event_state, opts)
            require("avante.providers").openai.parse_response(data_stream, event_state, opts)
          end,
        },
      },
    },
    dependencies = {
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below is optional, make sure to setup it properly if you have lazy=true
      {
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  }

})
