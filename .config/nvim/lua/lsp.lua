local function has_cmd(cmd)
  return vim.fn.executable(cmd) == 1
end

-- Capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()

-- Servers
local servers = {
  ts_ls = {
    cmd = { "typescript-language-server", "--stdio" },
    filetypes = {
      "javascript", "javascriptreact", "javascript.jsx",
      "typescript", "typescriptreact", "typescript.tsx"
    },
  },
  lua_ls = {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    settings = {
      Lua = {
        diagnostics = { globals = { "vim", "Snacks" } },
      },
    },
  },
  html = {},
  cssls = {},
  pyright = {},
  gopls = {},
  clangd = {},
}

-- Setup each server using new API
for server, config in pairs(servers) do
  if has_cmd(config.cmd and config.cmd[1] or server) then
    config.capabilities = vim.tbl_deep_extend("force", {}, capabilities, config.capabilities or {})
    vim.lsp.config[server] = config
    vim.lsp.enable(server)
  end
end

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
