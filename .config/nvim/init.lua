vim.g.mapleader = " "
-- vim.pack.update()
vim.pack.add({
  "https://github.com/MeanderingProgrammer/render-markdown.nvim.git",
  "https://github.com/folke/flash.nvim",
  "https://github.com/chomosuke/typst-preview.nvim",
  "https://github.com/folke/which-key.nvim",
  "https://github.com/voldikss/vim-floaterm",
  "https://github.com/h-jangra/bare.min",
  "https://github.com/prichrd/netrw.nvim",
})
require("bare")
require("render-markdown").setup()
require("which-key").setup()
vim.keymap.set("n", "<cr>", function() require("flash").jump() end, { desc = "Flash" })

--____OPTIONS____
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.opt.scrolloff = 8
vim.opt.wrap = true
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

vim.diagnostic.config({
  virtual_text = { current_line = true }
})

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ higroup = "Visual", timeout = 200 })
  end,
})

--____KEYMAPS___
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- NORMAL MODE
map("n", "<esc>", "<cmd>noh<cr>", opts)

map("n", "<leader>o", "<cmd>update<cr> :source<cr>", opts)
map("n", "<leader>q", "<cmd>quit<cr>", opts)
map("n", "<leader>w", "<Esc><cmd>w<CR><cmd>lua vim.lsp.buf.format({ async = true })<CR>", { desc = "Save & Format" })
map("n", "<C-s>", "<cmd>write<cr>", opts)

-- Window navigation
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Search + scroll
map("n", "n", "nzzzv", opts)
map("n", "N", "Nzzzv", opts)
map("n", "<C-d>", "<C-d>zz", opts)
map("n", "<C-u>", "<C-u>zz", opts)

-- Move lines
map("n", "<A-k>", ":m .-2<CR>==", opts)
map("n", "<A-j>", ":m .+1<CR>==", opts)

-- Select all / copy
map("n", "<leader>a", "ggVG", opts)
map("n", "<c-c>", "<cmd>%y+<cr>", opts)
map("n", "x", '"_x', opts)
map("x", "c", '"_c', opts)

-- Buffers
map("n", "<tab>", "<cmd>bnext<cr>", opts)
map("n", "<s-tab>", "<cmd>bprevious<cr>", opts)
map("n", "<leader>x", "<cmd>bdelete!<cr>", opts)

-- Yank & paste
map("n", "<leader>y", 'm`"0yy"0p``', opts)

map("n", "<C-j>", function()
  vim.diagnostic.jump({ count = 1 })
end, opts)

map("n", "<leader>lf", function() vim.lsp.buf.format({ async = true }) end, { desc = "LSP Format" })
map("n", "<leader>li", "g=G``", { desc = "Indent file" })

map("n", "<leader>cd", function()
  local diags = vim.diagnostic.get(0, { lnum = vim.api.nvim_win_get_cursor(0)[1] - 1 })
  if #diags > 0 then
    vim.fn.setreg("+", table.concat(vim.tbl_map(function(d) return d.message end, diags), "\n"))
    vim.notify("Diagnostics copied", vim.log.levels.INFO)
  else
    vim.notify("No diagnostics", vim.log.levels.INFO)
  end
end, { desc = "Copy line diagnostics" })

-- Find & replace
map("n", "<leader>fr", function()
  local find = vim.fn.input("Find: ")
  local replace = vim.fn.input("Replace with: ")
  vim.cmd(string.format("%%s/%s/%s/gc", find, replace))
end, { desc = "Find and replace" })

map("n", "<leader>fc", function()
  vim.cmd("e " .. vim.fn.stdpath("config"))
end, { desc = "Open config" })

-- INSERT MODE
map("i", "<A-k>", "<esc>:m .-2<CR>==gi", opts)
map("i", "<A-j>", "<esc>:m .+1<CR>==gi", opts)
map("i", "jk", "<esc>", opts)
map("i", "kj", "<esc>", opts)
map("i", "<C-s>", "<Esc><cmd>w<CR><cmd>lua vim.lsp.buf.format({ async = true })<CR>", opts)

-- VISUAL MODE
map("v", "<A-k>", ":m '<-2<CR>gv=gv", opts)
map("v", "<A-j>", ":m '>+1<CR>gv=gv", opts)
map("v", "<leader>y", '"1y`>"0p', opts)
map("v", "x", '"_x', opts)
map("v", "c", '"_c', opts)

map("x", "<leader>y", '"1y`>"0p', opts)
