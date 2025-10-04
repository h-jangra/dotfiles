-- Winbar module
local has_icons, devicons = pcall(require, 'nvim-web-devicons')

-- Function to build winbar with icons
function _G.get_winbar()
  local buffers = {}
  local cwd = vim.fn.getcwd()
  local current = vim.api.nvim_get_current_buf()

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted then
      -- Get full and tail names
      local full = vim.api.nvim_buf_get_name(buf)
      local name = full == '' and '[No Name]'
          or vim.fn.fnamemodify(full, ':t')
      -- Get icon
      local icon, icon_hl = ''
      if has_icons and full ~= '' then
        local ext = vim.fn.fnamemodify(full, ':e')
        icon, icon_hl = devicons.get_icon(full, ext, { default = true })
        icon = icon and (icon .. ' ') or ''
      end
      -- Modified flag
      local modified = vim.bo[buf].modified and '' or ''
      -- Highlight groups
      local hl = buf == current and '%#WinBarCurrent#'
          or '%#WinBar#'
      -- Clickable area
      local click = '%' .. buf .. '@v:lua.switch_to_buffer@'
      table.insert(buffers, hl .. click .. ' ' .. icon .. name .. modified .. ' %*')
    end
  end

  return #buffers > 0
      and table.concat(buffers, '%#WinBarSep# │ %*')
      or ''
end

-- Buffer-switching callback
function _G.switch_to_buffer(bufnr)
  vim.api.nvim_set_current_buf(bufnr)
end

-- Setup winbar
vim.opt.winbar = '%{%v:lua.get_winbar()%}'

-- Auto-refresh on buffer changes
vim.api.nvim_create_autocmd({ 'BufAdd', 'BufDelete', 'BufEnter' }, {
  callback = function() vim.cmd('redrawstatus') end,
})

-- Highlight groups (adjust colors as desired)
vim.api.nvim_create_autocmd('ColorScheme', {
  callback = function()
    vim.api.nvim_set_hl(0, 'WinBar', { fg = '#7f849c' })
    vim.api.nvim_set_hl(0, 'WinBarCurrent', { fg = '#c0caf5', bold = true })
    vim.api.nvim_set_hl(0, 'WinBarSep', { fg = '#545c7e' })
    vim.api.nvim_set_hl(0, 'DevIconDefault', { fg = '#6d8086' })
  end,
})

-- Trigger initial highlights
vim.cmd('doautocmd ColorScheme')
