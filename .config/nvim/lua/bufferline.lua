-- Define highlights on colorscheme load
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    local function hl(name, opts) vim.api.nvim_set_hl(0, name, opts) end
    hl("WinBarActive", { fg = "#7fb4ca", bg = "#2a2a37", bold = true })
    hl("WinBarInactive", { fg = "#54546d", bg = "#2a2a37" })
    hl("WinBarModified", { fg = "#7fb4ca", bg = "#454555", bold = true })
    hl("WinBarModifiedInactive", { fg = "#54546d", bg = "#454555" })
    hl("WinBarIconActive", { fg = "#7fb4ca", bg = "#2a2a37" })
    hl("WinBarIconModified", { fg = "#7fb4ca", bg = "#454555" })
    hl("WinBarIconInactive", { fg = "#727289", bg = "#2a2a37" })
    hl("WinBarIconModifiedInactive", { fg = "#727289", bg = "#454555" })
    hl("WinBarSep", { fg = "#54546d", bg = "#2a2a37" })
  end,
})

-- Trigger it immediately once
vim.cmd("doautocmd ColorScheme")

local icons = require("icons")

-- Click handler
function _G.winbar_goto_buf(bufnr, _)
  if vim.api.nvim_buf_is_loaded(bufnr) then
    vim.api.nvim_set_current_buf(bufnr)
  end
end

-- Build bufferline-like winbar
function _G.winbar_buffers()
  local cur   = vim.api.nvim_get_current_buf()
  local bufs  = vim.api.nvim_list_bufs()
  local parts = {}

  for _, bufnr in ipairs(bufs) do
    if vim.bo[bufnr].buflisted then
      local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":t")
      if name == "" then name = "[No Name]" end

      local is_mod = vim.bo[bufnr].modified
      local is_cur = bufnr == cur

      local group, icon_group
      if is_cur and is_mod then
        group = "WinBarModified"
        icon_group = "WinBarIconModified"
      elseif is_cur then
        group = "WinBarActive"
        icon_group = "WinBarIconActive"
      elseif is_mod then
        group = "WinBarModifiedInactive"
        icon_group = "WinBarIconModifiedInactive"
      else
        group = "WinBarInactive"
        icon_group = "WinBarIconInactive"
      end

      -- Safely get icon
      local icon = icons.get(vim.bo[bufnr].filetype)
      if not icon or icon == "" then
        icon = "󰈚" -- fallback glyph (nf-mdi-file)
      end

      local icon_segment = string.format("%%#%s# %s ", icon_group, icon)

      -- Clickable buffer segment
      local segment = string.format(
        "%%%d@v:lua.winbar_goto_buf@%%#%s#%s%s %%X",
        bufnr, group, icon_segment, name
      )

      table.insert(parts, segment)
    end
  end

  return table.concat(parts, "%#Normal# ")
end

-- Assign winbar globally
vim.o.winbar = "%{%v:lua.winbar_buffers()%}"

-- Refresh when buffer events happen
vim.api.nvim_create_autocmd(
  { "BufEnter", "BufWinEnter", "BufWritePost", "TabEnter", "WinEnter", "BufModifiedSet" },
  { callback = function() vim.cmd("redrawstatus") end }
)
