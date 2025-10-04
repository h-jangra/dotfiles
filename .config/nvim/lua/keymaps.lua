vim.g.mapleader = " "

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- NORMAL MODE

map("n", "<esc>", "<cmd>noh<cr>", opts)

-- Save & Source
map("n", "<leader>o", "<cmd>update<cr> :source<cr>", opts)
map("n", "<leader>q", "<cmd>quit<cr>", opts)
map("n", "<leader>w", "<Esc><cmd>w<CR><cmd>lua vim.lsp.buf.format({ async = true })<CR>", { desc = "Save & Format" })
map("n", "<C-s>", "<cmd>write<cr>", opts)

-- Window navigation
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Search + scroll (center cursor)
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

-- Buffers
map("n", "<tab>", "<cmd>bnext<cr>", opts)
map("n", "<s-tab>", "<cmd>bprevious<cr>", opts)
map("n", "<leader>x", "<cmd>bdelete!<cr>", opts)

-- Yank & paste
map("n", "<leader>y", 'm`"0yy"0p``', opts)

-- Diagnostics
map("n", "<C-j>", function()
  vim.diagnostic.jump({ count = 1 })
end, opts)

-- Snacks / Pickers
map("n", "<leader><leader>", "<cmd>lua Snacks.picker.files()<cr>", opts)
map("n", "<leader>e", "<cmd>lua Snacks.explorer()<cr>", opts)
map("n", "<leader>sp", "<cmd>lua Snacks.picker()<cr>", opts)
map("n", "<leader>sw", function() Snacks.picker.grep() end, { desc = "Grep Word" })
map("n", "<leader>n", "<cmd>lua Snacks.picker.notifications()<cr>", opts)

-- LSP
map("n", "<leader>lf", vim.lsp.buf.format, { desc = "Format" })
map("n", "<leader>li", "g=G``", { desc = "Format" })

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
