-- Disable built-in plugins
vim.g.loaded_gzip = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_vimball = 1
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1
vim.g.loaded_logiPat = 1
vim.g.loaded_rrhelper = 1
vim.g.loaded_spellfile_plugin = 1
vim.g.loaded_tutor_mode_plugin = 1
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrwSettings = 1
vim.g.loaded_netrwFileHandlers = 1

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
-------------------------------------------------
local opt = vim.opt

-- Display
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.scrolloff = 8
opt.wrap = false
opt.mouse = "a"
opt.termguicolors = true
opt.laststatus = 3
opt.shortmess:append("I")
opt.completeopt = { "menu", "menuone", "noselect" }
opt.winborder = "rounded"

-- Indentation
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.smartindent = true

-- File handling
opt.undofile = true
opt.undodir = vim.fn.stdpath("data") .. "/undodir"
opt.swapfile = false
opt.backup = false
opt.autoread = true

-- Performance
opt.synmaxcol = 240
opt.lazyredraw = true
opt.updatetime = 200
opt.timeoutlen = 300
opt.ttimeoutlen = 10
opt.mousescroll = "ver:5,hor:0"

-------------------------------------------------
vim.pack.add({ "https://github.com/h-jangra/bare.min" })
require("bare")
-------------------------------------------------
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })
-------------------------------------------------
vim.diagnostic.config({
  virtual_text = { current_line = true },
})


-------------------------------------------------
local augroup = vim.api.nvim_create_augroup("UserConfig", { clear = true })

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  callback = function()
    vim.highlight.on_yank({ higroup = "Visual", timeout = 150 })
  end,
})

-- Auto-format on save (synchronous to ensure completion)
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup,
  callback = function(args)
    local clients = vim.lsp.get_clients({ bufnr = args.buf })
    if #clients > 0 then
      vim.lsp.buf.format({ async = false, timeout_ms = 1000 })
    end
  end,
})

-------------------------------------------------
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- General
map("n", "<Esc>", "<cmd>nohlsearch<cr>", opts)
map("n", "<C-s>", "<cmd>w<cr>", opts)
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save" })
map("n", "<leader>o", "<cmd>update<cr>:source %<cr>", { desc = "Save & Reload" })
map("n", "<A-q>", "<cmd>q<cr>", opts)
map("n", "<leader>a", "ggVG", { desc = "Select All" })

-- Clipboard
map({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to Clipboard" })
map("n", "<leader>Y", '"+Y', { desc = "Yank Line to Clipboard" })
map({ "n", "v" }, "<leader>p", '"+p', { desc = "Paste from Clipboard" })
map("n", "<C-c>", "<cmd>%y+<cr>", { desc = "Copy File to Clipboard" })

-- Buffers
map("n", "<Tab>", "<cmd>bnext<cr>", opts)
map("n", "<S-Tab>", "<cmd>bprevious<cr>", opts)
map("n", "<leader>x", "<cmd>bdelete!<cr>", { desc = "Close Buffer" })

-- Window navigation
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Better search centering
map("n", "n", "nzzzv", opts)
map("n", "N", "Nzzzv", opts)
map("n", "<C-d>", "<C-d>zz", opts)
map("n", "<C-u>", "<C-u>zz", opts)

-- Move lines
map("n", "<A-j>", ":m .+1<cr>==", opts)
map("n", "<A-k>", ":m .-2<cr>==", opts)
map("i", "<A-j>", "<Esc>:m .+1<cr>==gi", opts)
map("i", "<A-k>", "<Esc>:m .-2<cr>==gi", opts)
map("v", "<A-j>", ":m '>+1<cr>gv=gv", opts)
map("v", "<A-k>", ":m '<-2<cr>gv=gv", opts)

-- Better delete/change (don't yank)
map("n", "x", '"_x', opts)
map("v", "x", '"_x', opts)
map("v", "c", '"_c', opts)
map("x", "c", '"_c', opts)

-- Find and replace
map("n", "<leader>fr", function()
  local find = vim.fn.input("Find: ")
  if find == "" then return end
  local replace = vim.fn.input("Replace: ")
  vim.cmd(string.format("%%s/%s/%s/gc", vim.fn.escape(find, "/\\"), vim.fn.escape(replace, "/\\")))
end, { desc = "Find & Replace" })

-- Copy diagnostics to clipboard
map("n", "<leader>cd", function()
  local line = vim.api.nvim_win_get_cursor(0)[1] - 1
  local diags = vim.diagnostic.get(0, { lnum = line })
  if #diags > 0 then
    local messages = vim.tbl_map(function(d) return d.message end, diags)
    vim.fn.setreg("+", table.concat(messages, "\n"))
    vim.notify("Diagnostics copied to clipboard", vim.log.levels.INFO)
  else
    vim.notify("No diagnostics on this line", vim.log.levels.WARN)
  end
end, { desc = "Copy Line Diagnostics" })

-- LSP
map("n", "<leader>lf", function()
  vim.lsp.buf.format({ async = true, timeout_ms = 2000 })
end, { desc = "LSP Format" })
map("n", "<leader>li", "gg=G``", { desc = "Indent Entire File" })

-- Config access
map("n", "<leader>fc", function()
  vim.cmd("edit " .. vim.fn.stdpath("config") .. "/init.lua")
end, { desc = "Edit Config" })

-- Insert mode shortcuts
map("i", "jk", "<Esc>", opts)
map("i", "kj", "<Esc>", opts)
map("i", "<C-s>", "<Esc><cmd>w<cr>", opts)
