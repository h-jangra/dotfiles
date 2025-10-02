require("keymaps")
require("plugins")
require("autocmds")
require("lsp")
require("snippet").setup_keymap()

-- OPTIONS --
vim.o.syntax = "ON"                  -- set syntax to ON
vim.o.backup = false                 -- turn off backup file
vim.o.writebackup = false            -- do not write backup
vim.o.swapfile = false               -- turn off swapfile
vim.o.undofile = true                -- set undo file
vim.o.undodir = vim.fn.expand("~/.local/share/nvim/undodir")
vim.o.updatetime = 300               -- decrease update time to improve snappiness
vim.o.cursorline = true              -- set highlighted cursor line
vim.o.autoread = true                -- re-read files in case they were edited outside of vim
vim.o.autowrite = false              -- do not auto write file when changing buffers and such
vim.o.compatible = false             -- turn off vi compatibility mode
vim.o.number = true                  -- turn on line numbers
vim.o.relativenumber = true          -- turn on relative line numbers
vim.o.mouse = 'a'                    -- enable the mouse in all modes
vim.o.ignorecase = true              -- enable case insensitive searching
vim.o.smartcase = true               -- all searches are case insensitive unless there's a capital letter
vim.o.smartindent = true             -- smart auto-indenting when starting a new line
vim.o.hlsearch = false               -- disable all highlighted search results
vim.o.incsearch = true               -- enable incremental searching
vim.o.wrap = false                   -- enable text wrapping
vim.o.tabstop = 4                    -- tabs=4spaces
vim.o.shiftwidth = 4                 -- tabs=4spaces
vim.o.expandtab = true               -- convert tabs to spaces
vim.o.fileencoding = "utf-8"         -- encoding set to utf-8
vim.o.pumheight = 10                 -- number of items in popup menu
vim.o.laststatus = 2                 -- always show statusline
vim.o.signcolumn = "auto"            --  only use sign column when there is something to put there
vim.o.colorcolumn = "80"             -- set color column to 80 characters
vim.o.showcmd = true                 -- show the command
vim.o.showmatch = true               -- highlight matching brackets
vim.o.cmdheight = 1                  -- set command line height
vim.o.showmode = false               -- do not show the mode since it's already in the status line
vim.o.scrolloff = 8                  -- scroll page when cursor is 8 lines from top/bottom
vim.o.sidescrolloff = 8              -- scroll page when cursor is 8 spaces from left/right
vim.o.clipboard = "unnamedplus"      -- use the system clipboard
vim.o.wildmenu = true                -- use the wild menu
vim.o.wildmode = "longest:full,full" -- set wile menu options
vim.o.path = "+=**"                  -- search files recursively
vim.o.splitbelow = true              -- split go below
vim.o.splitright = true              -- vertical split to the right
vim.o.termguicolors = true           -- terminal gui colors
vim.o.cmdwinheight = 10              -- cmd window can only take up this many lines
vim.opt.guifont = { "JetBrainsMono Nerd Font", ":h14" }
vim.opt.completeopt = { "menuone", "noselect" }

vim.cmd("filetype plugin on")
vim.cmd("colorscheme vague")
require("vim._extui").enable({})

vim.g.netrw_banner = 0
vim.g.netrw_browse_split = 0
vim.g.netrw_liststyle = 3
