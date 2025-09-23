require("keymaps")
require("plugins")
require("autocmds")
require("lsp")
require("snippet").setup_keymap()

local o = vim.opt

o.number = true
o.relativenumber = true
o.mouse = "a"
o.wrap = true
o.tabstop = 2
o.shiftwidth = 2
o.expandtab = true
o.smartindent = true
o.termguicolors = true
o.cursorline = true
o.signcolumn = "yes"
o.splitbelow = true
o.swapfile = false
o.splitright = true
o.scrolloff = 8
o.updatetime = 250
o.timeoutlen = 300
o.ignorecase = true
o.smartcase = true
o.clipboard = "unnamedplus"
o.linespace = 12
o.winborder = "rounded"

vim.cmd("colorscheme vague")

require("vim._extui").enable({})
