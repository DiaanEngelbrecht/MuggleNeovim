require("which-key").setup {
	-- your configuration comes here
}

local wk = require("which-key")

wk.register({
	f = {
		name = "Files", -- optional group name
		f = { "Find File" },
		j = { "File browser" },
		s = { "Save" },
		-- ["1"] = "which_key_ignore",  -- special label to hide it in the popup
		-- b = { function() print("bar") end, "Foobar" } -- you can also pass functions!
	},
	p = {
		name = "Projects",
		f = { "Find File" },
	},
	l = {
		name = "LSP",
		f = { function()
			vim.lsp.buf.formatting()
		end, "Format buffer" },
		l = { "<cmd>:LspInfo<cr>", "LSP Info" },
		s = { "<cmd>:Mason<cr>", "LSP Servers" }
	},
	w = {
		name = "Windows",
		d = { "Delete current window" },
		s = { "Split Horizontally" },
		v = { "Split Vertically" },
	},
  g = {
    name = "Git",
    s = { "Status" }
  },
	b = {
		name = "Buffers",
		b = { "List buffers" },
		d = { "Delete current buffer" },
	},
	["<tab>"] = {
		name = "Switch buffers"
	},
	["/"] = {
		"Search"
	},
	q = "which_key_ignore"

}, { prefix = "<leader>" })
