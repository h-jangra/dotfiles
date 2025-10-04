-- vim.pack.update()
vim.pack.add({
  { src = "https://github.com/MeanderingProgrammer/render-markdown.nvim.git" },
  { src = "https://github.com/Saghen/blink.cmp" },
  { src = "https://github.com/chomosuke/typst-preview.nvim" },
  { src = "https://github.com/folke/flash.nvim" },
  { src = "https://github.com/folke/snacks.nvim" },
  { src = "https://github.com/folke/which-key.nvim" },
  { src = "https://github.com/mason-org/mason.nvim" },
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/nvim-mini/mini.nvim" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
  { src = "https://github.com/vague2k/vague.nvim" },
  { src = "https://github.com/windwp/nvim-ts-autotag" },
  { src = "https://github.com/williamboman/mason-lspconfig.nvim" },
  { src = "https://github.com/voldikss/vim-floaterm" },
  { src = "https://github.com/nvim-tree/nvim-web-devicons.git" },
})

require("nvim-treesitter.configs").setup({ ensure_installed = { "typescript", "javascript" }, highlight = { enable = true } })
require("vague").setup({ transparent = true })
require("render-markdown").setup()
require("mason").setup()
require("mason-lspconfig").setup()
require("flash").setup()
require("which-key").setup()
-- require("mini.surround").setup()
-- require("mini.ai").setup()
-- require("mini.tabline").setup()
require("mini.icons").setup()
-- require("mini.pairs").setup()
-- require("mini.hipatterns").setup()
-- require("mini.trailspace").setup()

require("liveserver").setup()

require("blink.cmp").setup({
  keymap = { preset = "default", ["<CR>"] = { "accept", "fallback" }, },

  appearance = {
    nerd_font_variant = "mono",
  },

  completion = {
    documentation = { auto_show = true },
  },

  sources = {
    default = { "lsp", "path", "snippets", "buffer" },
  },

  fuzzy = { implementation = "lua" },
})

require("snacks").setup(
  {
    explorer = { enabled = true },
    picker = { enabled = true },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    scroll = { enabled = true },
  }
)

require('nvim-ts-autotag').setup({
  opts = {
    enable_close = true,
    enable_rename = true,
    enable_close_on_slash = false
  },
  per_filetype = {
    ["html"] = { enable_close = false }
  }
})

vim.keymap.set("n", "<cr>", function() require("flash").jump() end, { desc = "Flash" })

