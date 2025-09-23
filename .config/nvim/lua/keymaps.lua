vim.g.mapleader = " "

local utils = require("autocmds")

local keymaps = {
  n = {

    ["<esc>"] = "<cmd>noh<cr>",
    ["<leader>o"] = "<cmd>update<cr> :source<cr>",
    ["<leader>q"] = "<cmd>quit<cr>",

    -- Save file
    ["<leader>w"] = { "<Esc><cmd>w<CR><cmd>lua vim.lsp.buf.format({ async = true })<CR>",
      { desc = "Save & Format file" } },
    ["<C-s>"] = "<cmd>write<cr>",

    -- Move b/w windows
    ["<C-h>"] = "<C-w>h",
    -- ["<C-j>"] = "<C-w>j",
    ["<C-k>"] = "<C-w>k",
    ["<C-l>"] = "<C-w>l",

    -- search + scroll
    ["n"] = "nzzzv",
    ["N"] = "Nzzzv",
    ["<C-d>"] = "<C-d>zz",
    ["<C-u>"] = "<C-u>zz",

    -- move lines
    ["<A-k>"] = ":m .-2<CR>==",
    ["<A-j>"] = ":m .+1<CR>==",

    -- select all / copy
    ["<leader>a"] = "ggVG",
    ["<c-c>"] = "<cmd>%y+<cr>",

    ["x"] = '"_x',

    -- buffers
    ["<tab>"] = "<cmd>bnext<cr>",
    ["<s-tab>"] = "<cmd>bprevious<cr>",
    ["<leader>x"] = "<cmd>bdelete!<cr>",

    -- yank
    ["<leader>y"] = 'm`"0yy"0p``',

    -- diagnostics
    ["<C-j>"] = {
      function()
        vim.diagnostic.jump({ count = 1 })
      end,
    },

    -- snacks / mini / lsp
    ["<leader><leader>"] = "<cmd>lua Snacks.picker.files()<cr>",
    -- ["<leader>h"] = "<cmd>Pick help<cr>",
    ["<leader>e"] = "<cmd>lua Snacks.explorer()<cr>",
    ["<leader>sp"] = "<cmd>lua Snacks.picker()<cr>",
    ["<leader>sw"] = {
      function()
        Snacks.picker.grep()
      end,
      { desc = "Grep Word" },
    },
    -- ["<leader>fe"] = "<cmd>lua MiniFiles.open()<cr>",
    ["<leader>lf"] = { vim.lsp.buf.format, { desc = "Format" } },
    ["<leader>li"] = { "g=G``", { desc = "Format" } },

    -- find & replace
    ["<leader>fr"] = {
      function()
        local cmd = string.format("%%s/%s/%s/gc", vim.fn.input("find: "), vim.fn.input("replace with: "))
        vim.cmd(cmd)
      end,
      { desc = "Find and replace a word" },
    },

    ["<leader>fc"] = "<cmd>e" .. vim.fn.stdpath("config") .. "<cr>",
    ["<leader>n"] = "<cmd>lua Snacks.picker.notifications()<cr>"
  },

  i = {
    ["<A-k>"] = "<esc>:m .-2<CR>==gi",
    ["<A-j>"] = "<esc>:m .+1<CR>==gi",

    ["jk"] = "<esc>",
    ["kj"] = "<esc>",
    ["<C-s>"] = "<Esc><cmd>w<CR><cmd>lua vim.lsp.buf.format({ async = true })<CR>",
  },

  v = {
    ["<A-k>"] = ":m '<-2<CR>gv=gv",
    ["<A-j>"] = ":m '>+1<CR>gv=gv",
    ["<leader>y"] = '"1y`>"0p',

    ["x"] = '"_x',
    ["c"] = '"_c',
  },

  x = {
    ["<leader>y"] = '"1y`>"0p',
  },

  all = {},
}

utils.apply_keymaps({
  n = keymaps.n,
  i = keymaps.i,
  v = keymaps.v,
  x = keymaps.x,
})

for _, mode in ipairs({ "n", "i", "v" }) do
  utils.apply_keymaps({ [mode] = keymaps.all })
end
