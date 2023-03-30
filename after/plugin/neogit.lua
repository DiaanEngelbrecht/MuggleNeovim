local neogit = require('neogit')

neogit.setup {
  use_magit_keybindings = true,
  disable_hint = true,
  disable_context_highlighting = true,
  disable_commit_confirmation = true,
  auto_refresh = false,
  kind = "split",
  integrations = {
    diffview = true
  }
}
