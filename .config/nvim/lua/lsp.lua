local lua_ls_config = {
  name = "lua_ls",
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_dir = vim.fs.root(0, {".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml", "selene.yml", ".git"}),
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      telemetry = { enable = false },
    },
  },
}

vim.api.nvim_create_autocmd("FileType", {
  pattern = "lua",
  callback = function()
    vim.lsp.start(lua_ls_config)
  end,
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
