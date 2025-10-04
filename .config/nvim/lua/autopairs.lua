local M = {}

local pairs = {
  ["("] = ")",
  ["["] = "]",
  ["{"] = "}",
  ['"'] = '"',
  ["'"] = "'",
  ["`"] = "`",
}

function M.setup()
  for open, close in pairs(pairs) do
    vim.keymap.set("i", open, open .. close .. "<Left>", { silent = true })
    vim.keymap.set("i", close, function()
      local col = vim.fn.col(".")
      local line = vim.fn.getline(".")
      if line:sub(col, col) == close then
        return "<Right>"
      end
      return close
    end, { expr = true, silent = true })
  end

  vim.keymap.set("i", "<CR>", function()
    local col = vim.fn.col(".")
    local line = vim.fn.getline(".")
    local before = line:sub(col - 1, col - 1)
    local after = line:sub(col, col)
    if pairs[before] == after then
      return "<CR><Esc>O"
    end
    return "<CR>"
  end, { expr = true, silent = true })
end

return M
