local M = {}

-- Default LSP servers
M.servers = {
  lua_ls = {
    name = "lua_ls",
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    root_patterns = { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml", "selene.yml", ".git" },
    settings = {
      Lua = {
        runtime = { version = "LuaJIT" },
        diagnostics = { globals = { "vim" } },
        workspace = { library = vim.api.nvim_get_runtime_file("", true), checkThirdParty = false },
        telemetry = { enable = false },
      },
    },
  },

  pyright = {
    name = "pyright",
    cmd = { "pyright-langserver", "--stdio" },
    filetypes = { "python" },
    root_patterns = { "pyproject.toml", "setup.py", ".git" },
  },

  html = {
    name = "html",
    cmd = { "vscode-html-language-server", "--stdio" },
    filetypes = { "html" },
    root_patterns = { ".git" },
  },

  cssls = {
    name = "cssls",
    cmd = { "vscode-css-language-server", "--stdio" },
    filetypes = { "css", "scss", "less" },
    root_patterns = { ".git" },
  },

  jsonls = {
    name = "jsonls",
    cmd = { "vscode-json-language-server", "--stdio" },
    filetypes = { "json", "jsonc" },
    root_patterns = { "package.json", ".git" },
  },

  ts_ls = {
    name = "ts_ls",
    cmd = { "typescript-language-server", "--stdio" },
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    root_patterns = { "package.json", "tsconfig.json", ".git" },
  },

  gopls = {
    name = "gopls",
    cmd = { "gopls" },
    filetypes = { "go", "gomod", "gowork", "gotmpl" },
    root_patterns = { "go.mod", ".git" },
  },

  rust_analyzer = {
    name = "rust_analyzer",
    cmd = { "rust-analyzer" },
    filetypes = { "rust" },
    root_patterns = { "Cargo.toml", ".git" },
  },

  tinymist = {
    name = "tinymist",
    cmd = { "tinymist", "lsp" },
    filetypes = { "typst", "typ" },
    root_patterns = { "typst.toml", ".git" },
    single_file_support = true,
  },
}

-- Check if command exists
local function executable(cmd)
  return vim.fn.executable(cmd) == 1
end

-- Determine root_dir safely
local function get_root_dir(patterns, bufnr)
  bufnr = bufnr or 0
  local fname = vim.api.nvim_buf_get_name(bufnr)
  local root = vim.fs.root(fname, patterns)
  return root or vim.fn.getcwd()
end

-- Enhanced capabilities
local function get_capabilities()
  local caps = vim.lsp.protocol.make_client_capabilities()
  caps.textDocument.completion.completionItem.snippetSupport = true
  caps.textDocument.completion.completionItem.resolveSupport = {
    properties = { "documentation", "detail", "additionalTextEdits" },
  }
  -- Ensure formatting is supported
  caps.textDocument.formatting = true
  caps.textDocument.rangeFormatting = true
  return caps
end

-- Start LSP safely
function M.start_lsp(config, bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local cmd_name = config.cmd[1]

  if not executable(cmd_name) then
    vim.notify(string.format("LSP '%s' not found! Install manually.", config.name), vim.log.levels.WARN)
    return
  end

  local lsp_config = vim.deepcopy(config)
  lsp_config.root_dir = get_root_dir(config.root_patterns or {}, bufnr)
  lsp_config.capabilities = get_capabilities()

  local client_id = vim.lsp.start(lsp_config, { bufnr = bufnr })
  if not client_id then
    vim.notify(string.format("Failed to start LSP: %s", config.name), vim.log.levels.ERROR)
    return
  end

  local client = vim.lsp.get_client_by_id(client_id)
  if not client then return end

  -- Enable omnifunc
  vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

  -- Completion trigger
  vim.keymap.set("i", "<C-Space>", function()
    vim.lsp.completion.trigger()
  end, { buffer = bufnr, desc = "Trigger LSP completion" })

  -- Format keymap
  if client.server_capabilities.documentFormattingProvider then
    vim.keymap.set("n", "<leader>lf", function()
      vim.lsp.buf.format({ bufnr = bufnr, async = true })
    end, { buffer = bufnr, desc = "Format buffer with LSP" })
  end
end

-- Setup autocmd for all servers
function M.setup(user_servers)
  if user_servers then
    for k, v in pairs(user_servers) do
      M.servers[k] = v
    end
  end

  local group = vim.api.nvim_create_augroup("LspSetup", { clear = true })

  for _, config in pairs(M.servers) do
    vim.api.nvim_create_autocmd("FileType", {
      group = group,
      pattern = config.filetypes,
      callback = function(args)
        M.start_lsp(config, args.buf)
      end,
    })
  end
end

return M
