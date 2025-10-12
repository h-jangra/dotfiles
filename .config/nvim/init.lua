vim.g.mapleader = " "
-- vim.pack.update()
vim.pack.add({
  "https://github.com/chomosuke/typst-preview.nvim",
  "https://github.com/h-jangra/bare.min",
})
require("bare")
-------------------------------------------------
-- Options
-------------------------------------------------
local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.scrolloff = 8
opt.wrap = false
opt.mouse = "a"
opt.termguicolors = true
opt.laststatus = 3
opt.shortmess:append("I") -- no intro
opt.completeopt = { "menu", "menuone", "noselect" }

-- Indentation
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.smartindent = true

-- File handling
opt.undofile = true
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
opt.swapfile = false
opt.backup = false
opt.autoread = true

-- Performance
opt.lazyredraw = true
opt.synmaxcol = 240
opt.updatetime = 200
opt.ttimeoutlen = 10
opt.mousescroll = "ver:5,hor:0"

-- UI
opt.winborder = "rounded"

-------------------------------------------------
-- Diagnostics
-------------------------------------------------
vim.diagnostic.config({
  virtual_text = { current_line = true },
  float = { border = "rounded" },
})

-------------------------------------------------
-- Autocmds
-------------------------------------------------
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ higroup = "Visual", timeout = 200 })
  end,
})

-------------------------------------------------
-- Keymaps
-------------------------------------------------
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- General
map("n", "<Esc>", "<cmd>nohlsearch<cr>", opts)
map("n", "<C-s>", "<cmd>w<cr>", opts)
map("n", "<leader>w", "<cmd>w<cr><cmd>lua vim.lsp.buf.format({ async = true })<cr>", { desc = "Save & Format" })
map("n", "<leader>o", "<cmd>update<cr>:source<cr>", { desc = "Save & Reload Config" })
map("n", "<C-q>", "<cmd>q<cr>", opts)
map("n", "<leader>a", "ggVG", { desc = "Select All" })

-- Clipboard
map({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to System Clipboard" })
map("n", "<leader>Y", [["+Y]], { desc = "Yank Line to Clipboard" })
map({ "n", "v" }, "<leader>p", [["+p]], { desc = "Paste from System Clipboard" })
map("n", "<C-c>", "<cmd>%y+<cr>", { desc = "Copy File to Clipboard" })

-- Buffers
map("n", "<Tab>", "<cmd>bnext<cr>", opts)
map("n", "<S-Tab>", "<cmd>bprevious<cr>", opts)
map("n", "<leader>x", "<cmd>bdelete!<cr>", { desc = "Close Buffer" })

-- Movement
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

map("n", "n", "nzzzv", opts)
map("n", "N", "Nzzzv", opts)
map("n", "<C-d>", "<C-d>zz", opts)
map("n", "<C-u>", "<C-u>zz", opts)

-- Move lines
map("n", "<A-j>", ":m .+1<cr>==", opts)
map("n", "<A-k>", ":m .-2<cr>==", opts)
map("i", "<A-j>", "<esc>:m .+1<cr>==gi", opts)
map("i", "<A-k>", "<esc>:m .-2<cr>==gi", opts)
map("v", "<A-j>", ":m '>+1<cr>gv=gv", opts)
map("v", "<A-k>", ":m '<-2<cr>gv=gv", opts)

-- Edit & Replace
map("n", "x", '"_x', opts)
map("v", "x", '"_x', opts)
map("v", "c", '"_c', opts)

map("n", "<leader>fr", function()
  local find = vim.fn.input("Find: ")
  local replace = vim.fn.input("Replace: ")
  vim.cmd(string.format("%%s/%s/%s/gc", find, replace))
end, { desc = "Find & Replace" })

-- Diagnostics
map("n", "<C-j>", function() vim.diagnostic.jump({ count = 1 }) end, { desc = "Next Diagnostic" })
map("n", "<leader>cd", function()
  local diags = vim.diagnostic.get(0, { lnum = vim.api.nvim_win_get_cursor(0)[1] - 1 })
  if #diags > 0 then
    vim.fn.setreg("+", table.concat(vim.tbl_map(function(d) return d.message end, diags), "\n"))
    vim.notify("Diagnostics copied to clipboard", vim.log.levels.INFO)
  else
    vim.notify("No diagnostics on this line", vim.log.levels.INFO)
  end
end, { desc = "Copy Line Diagnostics" })

-- LSP
map("n", "<leader>lf", function() vim.lsp.buf.format({ async = true }) end, { desc = "LSP Format" })
map("n", "<leader>li", "g=G``", { desc = "Indent File" })

-- Config
map("n", "<leader>fc", function() vim.cmd("e " .. vim.fn.stdpath("config")) end, { desc = "Open Config" })

-- Insert mode
map("i", "jk", "<esc>", opts)
map("i", "kj", "<esc>", opts)
map("i", "<C-s>", "<Esc><cmd>w<cr><cmd>lua vim.lsp.buf.format({ async = true })<cr>", opts)
