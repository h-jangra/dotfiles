local lspconfig = require("lspconfig")

-- Check if a command exists on the system
local function has_cmd(cmd)
  return vim.fn.executable(cmd) == 1
end

-- Capabilities (native only)
local capabilities = vim.lsp.protocol.make_client_capabilities()

-- Servers
local servers = {
  ts_ls = {
    cmd = { "typescript-language-server", "--stdio" },
    filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" }

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

-- Setup each server
for server, config in pairs(servers) do
  if has_cmd(config.cmd and config.cmd[1] or server) then
    config.capabilities = vim.tbl_deep_extend("force", {}, capabilities, config.capabilities or {})
    lspconfig[server].setup(config)
  end
end

-- -- Completion settings
-- vim.opt.completeopt = { "menu", "menuone", "noselect" }
-- vim.o.omnifunc = "v:lua.vim.lsp.omnifunc"
--
-- -- Auto popup completion after typing
-- vim.api.nvim_create_autocmd("TextChangedI", {
--   callback = function()
--     local col = vim.fn.col(".") - 1
--     if col > 0 then
--       vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<C-x><C-o>", true, false, true), "n")
--     end
--   end,
-- })
-- vim.api.nvim_create_autocmd("TextChangedP", {
--   callback = function()
--     local col = vim.fn.col(".") - 1
--     if col > 0 then
--       vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<C-x><C-o>", true, false, true), "n")
--     end
--   end,
-- })

-- Diagnostics

-- Global diagnostic config
vim.diagnostic.config({
  virtual_lines = { current_line = true } })

-- Copy current line diagnostics to system clipboard

vim.keymap.set("n", "<leader>cd", function()
  local bufnr, lnum = 0, vim.api.nvim_win_get_cursor(0)[1] - 1
  local diags = vim.diagnostic.get(bufnr, { lnum = lnum })
  if #diags == 0 then return vim.notify("No diagnostics", vim.log.levels.INFO) end
  vim.fn.setreg("+", table.concat(vim.tbl_map(function(d) return d.message end, diags), "\n"))
  vim.notify("Diagnostics copied", vim.log.levels.INFO)
end, { desc = "Copy current line diagnostics" })
