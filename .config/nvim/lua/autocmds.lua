-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ higroup = "YankHighlight", timeout = 200 })
  end,
})

-- Custom colorscheme highlights
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    vim.api.nvim_set_hl(0, "CursorLine", { bg = "#1f1f1f" })
    vim.api.nvim_set_hl(0, "Comment", { fg = "#5c6370", italic = true })
    vim.api.nvim_set_hl(0, "Normal", { fg = "#c0caf5", bg = "#1a1b26" })
    vim.api.nvim_set_hl(0, "YankHighlight", { bg = "#2d3149" })
  end,
})

-- Markdown/Typst: Wrap text with bold/italic
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "typst" },
  callback = function()
    local opts = { noremap = true, silent = true, buffer = true }

    -- Bold: Ctrl+b
    vim.keymap.set("n", "<C-b>", 'viwdi*<C-r>"*<Esc>', opts)
    vim.keymap.set("v", "<C-b>", 'c*<C-r>"*<Esc>', opts)

    -- Italic: Ctrl+i
    vim.keymap.set("n", "<C-i>", 'viwdi_<C-r>"_<Esc>', opts)
    vim.keymap.set("v", "<C-i>", 'c_<C-r>"_<Esc>', opts)
  end,
})

