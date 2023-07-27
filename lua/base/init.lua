require("base.packer")
require("base.theme")
require("base.keybindings")
require("base.set")

vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "help",
    "dashboard",
    "NvimTree",
    "mason",
    "notify",
  },
  callback = function()
    vim.b.miniindentscope_disable = true
  end,
})
