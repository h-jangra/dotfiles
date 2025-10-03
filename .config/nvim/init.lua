require("keymaps")
require("plugins")
require("autocmds")

-- Enable syntax highlighting
vim.o.syntax = "on"

-- File backups & undo
vim.o.backup = false
vim.o.writebackup = false
vim.o.swapfile = false
vim.o.undofile = true
vim.o.undodir = vim.fn.stdpath("data") .. "/undo"

-- UI settings
vim.o.number = true
vim.o.relativenumber = true
vim.o.termguicolors = true
vim.o.laststatus = 2
vim.o.scrolloff = 8
vim.o.sidescrolloff = 8
vim.o.wrap = false

-- Searching
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.hlsearch = false
vim.o.incsearch = true

-- Tabs & indentation
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.smartindent = true

-- Mouse & clipboard
vim.o.mouse = "a"
vim.o.clipboard = "unnamedplus"

-- Splits
vim.o.splitbelow = true
vim.o.splitright = true

-- Completion
vim.opt.completeopt = { "menuone", "noselect" }

-- Performance
vim.o.updatetime = 300
vim.o.autoread = true

vim.cmd("filetype plugin on")
vim.cmd("colorscheme vague")
require("vim._extui").enable({})

vim.g.netrw_banner = 0
vim.g.netrw_browse_split = 0
vim.g.netrw_liststyle = 3

-- Diagnostics
vim.diagnostic.config({
  virtual_lines = { current_line = true },
})

-- Copy current line diagnostics to clipboard
vim.keymap.set("n", "<leader>cd", function()
  local bufnr, lnum = 0, vim.api.nvim_win_get_cursor(0)[1] - 1
  local diags = vim.diagnostic.get(bufnr, { lnum = lnum })
  if #diags == 0 then
    return vim.notify("No diagnostics", vim.log.levels.INFO)
  end
  vim.fn.setreg("+", table.concat(vim.tbl_map(function(d) return d.message end, diags), "\n"))
  vim.notify("Diagnostics copied", vim.log.levels.INFO)
end, { desc = "Copy current line diagnostics" })


-- =======================
-- Statusline
-- =======================

-- Define colors for modes
local mode_colors = {
  n     = { fg = "#ffffff", bg = "#005f87", name = "NORMAL" },
  i     = { fg = "#ffffff", bg = "#5f8700", name = "INSERT" },
  v     = { fg = "#ffffff", bg = "#af005f", name = "VISUAL" },
  V     = { fg = "#ffffff", bg = "#af005f", name = "V-LINE" },
  [""] = { fg = "#ffffff", bg = "#af005f", name = "V-BLOCK" },
  R     = { fg = "#ffffff", bg = "#d70000", name = "REPLACE" },
  c     = { fg = "#000000", bg = "#ffd700", name = "COMMAND" },
  t     = { fg = "#000000", bg = "#ffaf00", name = "TERMINAL" },
}

-- Setup highlights dynamically
local function set_hl(name, fg, bg)
  vim.cmd(string.format("highlight %s guifg=%s guibg=%s gui=bold", name, fg, bg))
end

-- Function to generate statusline
function _G.my_statusline()
  local mode = vim.api.nvim_get_mode().mode
  local m = mode_colors[mode] or { fg = "#ffffff", bg = "#444444", name = mode }
  set_hl("StatusLineMode", m.fg, m.bg)

  local file_icon = "" -- default file icon
  local file_name = vim.fn.expand('%:t') ~= "" and vim.fn.expand('%:t') or "NoName"
  local file_type = vim.bo.filetype ~= "" and vim.bo.filetype or "none"
  local file_encoding = vim.bo.fileencoding ~= "" and vim.bo.fileencoding or vim.o.encoding

  -- Change icon for known filetypes
  local ft_icons = {
    lua = "",
    javascript = "",
    typescript = "",
    json = "",
    html = "",
    css = "",
    markdown = "",
    python = "",
    java = "",
    toml = "",
    sh = "",
    typst = "",
  }
  if ft_icons[file_type] then
    file_icon = ft_icons[file_type]
  end

  local line = vim.fn.line('.')
  local col = vim.fn.col('.')
  local total = vim.fn.line('$')
  local percent = math.floor((line / total) * 100)

  return table.concat({
    "%#StatusLineMode#",  -- highlight for mode
    " " .. m.name .. " ", -- mode name
    "%#StatusLine#",      -- reset to default statusline colors
    "  " .. file_icon .. " " .. file_name .. " ",
    -- "| " .. file_type .. " [" .. file_encoding .. "] ",
    "%=",
    string.format(" %d:%d  %d ", line, col, total),
  })
end

-- Always show statusline
vim.o.statusline = "%!v:lua.my_statusline()"
