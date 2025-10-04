require("keymaps")
require("lsp")
require("plugins")
require("autocmds")
require("status")
require("autopairs")
require("tabline")

local opt = vim.opt
local g = vim.g

opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.wrap = false
opt.linebreak = true
opt.showmode = false
opt.conceallevel = 0

opt.expandtab = true   -- Use spaces instead of tabs
opt.shiftwidth = 2     -- Indent width
opt.tabstop = 2        -- Tab width
opt.softtabstop = 2    -- Backspace removes 2 spaces
opt.smartindent = true -- Smart auto-indenting
opt.shiftround = true  -- Round indent to multiple of shiftwidth

opt.ignorecase = true  -- Ignore case in search
opt.smartcase = true   -- Override ignorecase if search has uppercase
opt.hlsearch = false   -- Don't highlight search results
opt.incsearch = true   -- Incremental search

opt.undofile = true
opt.undodir = vim.fn.stdpath("data") .. "/undo"
opt.backup = false
opt.writebackup = false
opt.swapfile = false
opt.autoread = true

opt.termguicolors = true
opt.pumheight = 10 -- Max items in popup menu
opt.pumblend = 10  -- Transparent popup menu
opt.winblend = 0   -- No transparency for floating windows
opt.laststatus = 3
opt.showmatch = true
opt.splitbelow = true
opt.splitright = true
opt.completeopt = { "menu", "menuone", "noselect" }

opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.virtualedit = "block"
opt.formatoptions:remove({ "c", "r", "o" })

opt.lazyredraw = false
opt.synmaxcol = 240
opt.updatecount = 100

g.netrw_banner = 0
g.netrw_liststyle = 3
g.netrw_browse_split = 0
g.netrw_altv = 1
g.netrw_winsize = 25

vim.cmd.colorscheme("vague")
vim.diagnostic.config({ virtual_lines = { current_line = true }, })
