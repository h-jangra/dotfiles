require("autocmds")
require("keymaps")
require("plugins")
require("bare")

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.opt.scrolloff = 8
vim.opt.wrap = false
vim.o.winborder = "rounded"

vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.smartindent = true

vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("data") .. "/undo"
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.autoread = true

vim.opt.termguicolors = true
vim.opt.laststatus = 3
vim.opt.completeopt = { "menu", "menuone", "noselect" }

vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"

vim.opt.updatetime = 50

vim.g.netrw_banner = 0
vim.g.netrw_browse_split = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_winsize = 25

vim.cmd.colorscheme("vague")
vim.diagnostic.config({
  virtual_lines = { current_line = true },
})
