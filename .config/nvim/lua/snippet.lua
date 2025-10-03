local M = {}

M.snippets = {}

local function get_word_before_cursor()
  local row, col = (table.unpack or unpack)(vim.api.nvim_win_get_cursor(0))
  if col == 0 then return "", row - 1, 0 end
  local line = vim.api.nvim_get_current_line()
  local s = col
  while s > 0 do
    local ch = line:sub(s, s)
    if ch:match("[%w_]") then
      s = s - 1
    else
      break
    end
  end
  local word = line:sub(s + 1, col)
  return word, row - 1, s
end

local function delete_range(bufnr, row, start_col, end_col)
  vim.api.nvim_buf_set_text(bufnr, row, start_col, row, end_col, { "" })
end

local function try_expand(ft)
  local word, row0, s = get_word_before_cursor()
  if word == "" then return false end
  local list = M.snippets[ft]
  if not list then return false end
  for _, sn in ipairs(list) do
    if sn.trigger == word then
      delete_range(0, row0, s, s + #word)
      vim.snippet.expand(sn.body)
      return true
    end
  end
  return false
end

function M.add(ft, defs)
  M.snippets[ft] = M.snippets[ft] or {}
  vim.list_extend(M.snippets[ft], defs)
end

function M.setup_keymap()
  vim.keymap.set({ "i", "s" }, "<C-k>", function()
    if vim.snippet.active({ direction = 1 }) then
      vim.schedule(function() vim.snippet.jump(1) end)
      return
    end
    if try_expand(vim.bo.filetype) then
      return
    end
    vim.api.nvim_feedkeys(
      vim.api.nvim_replace_termcodes("<Tab>", true, false, true),
      "i",
      true
    )
  end, { silent = true, noremap = true })
end

return M
