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

vim.g.mapleader = " " -- Make sure to set `mapleader` before lazy so your mappings are correct
vim.g.maplocalleader = "\\" -- Same for `maplocalleader`

require("lazy").setup({
  "ojroques/nvim-bufdel",
  "xiyaowong/transparent.nvim",
  "navarasu/onedark.nvim",
  "christoomey/vim-tmux-navigator",
  "lukas-reineke/indent-blankline.nvim",
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.6',
    dependencies = { 'nvim-lua/plenary.nvim' }
  },
  "nvim-telescope/telescope-file-browser.nvim",
  "nvim-telescope/telescope-project.nvim",
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
  { "kevinhwang91/nvim-bqf",           ft = 'qf' },
  {
    "NeogitOrg/neogit",
    dependencies = {
      'nvim-lua/plenary.nvim',
      'sindrets/diffview.nvim'
    },
  },
  { "echasnovski/mini.nvim", branch = 'stable' },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { 'kyazdani42/nvim-web-devicons', opt = true }
  },

  "voldikss/vim-floaterm",
  "emmanueltouzery/agitator.nvim",
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
  }

})
