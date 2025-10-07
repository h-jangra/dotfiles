-- vim.pack.update()
vim.pack.add({
  "https://github.com/MeanderingProgrammer/render-markdown.nvim.git",
  "https://github.com/folke/flash.nvim",
  "https://github.com/Saghen/blink.cmp",
  "https://github.com/chomosuke/typst-preview.nvim",
  -- "https://github.com/folke/snacks.nvim",
  -- "https://github.com/folke/which-key.nvim",
  "https://github.com/mason-org/mason.nvim",
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/nvim-mini/mini.nvim",
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/vague2k/vague.nvim",
  "https://github.com/windwp/nvim-ts-autotag",
  "https://github.com/williamboman/mason-lspconfig.nvim",
  "https://github.com/voldikss/vim-floaterm",
  "https://github.com/h-jangra/bare.min",
})

-- require("nvim-treesitter.configs").setup({ ensure_installed = { "typescript", "javascript" }, highlight = { enable = true } })
require("vague").setup({ transparent = true })
require("render-markdown").setup()
require("mason").setup()
require("mason-lspconfig").setup()
-- require("which-key").setup()
require("mini.surround").setup()
require("mini.ai").setup()
require("mini.icons").setup()
require("mini.pairs").setup()
require("mini.hipatterns").setup()
require("mini.trailspace").setup()

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

-- require("snacks").setup(
--   {
--     explorer = { enabled = false },
--     picker = { enabled = true },
--     notifier = { enabled = true },
--     quickfile = { enabled = true },
--     scroll = { enabled = true },
--   }
-- )

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
