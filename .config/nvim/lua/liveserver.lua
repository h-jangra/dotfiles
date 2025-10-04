-- Usage:
--   local liveserver = require("liveserver")
--   liveserver.setup()
--
-- Commands:
--   :LiveServerStart [port]  - Start server (default port: 8080)
--   :LiveServerStop          - Stop server
--   :LiveServerToggle        - Toggle server on/off
--   :LiveServerStatus        - Show server status
--   :LiveServerOpen          - Open server in browser

local M = {}

-- Server state
local state = {
  job_id = nil,
  port = 8080,
  start_dir = nil,
}

--- Get the server URL
--- @return string url The full server URL
local function get_url()
  return string.format("http://localhost:%d/", state.port)
end

--- Check if the server is running
--- @return boolean running True if server is running
local function is_running()
  return state.job_id ~= nil
end

--- Open URL in default browser (cross-platform)
--- @param url string The URL to open
local function open_in_browser(url)
  local open_cmd
  if vim.fn.has("mac") == 1 then
    open_cmd = "open"
  elseif vim.fn.has("unix") == 1 then
    open_cmd = "xdg-open"
  elseif vim.fn.has("win32") == 1 then
    open_cmd = "start"
  else
    vim.notify("Cannot detect OS to open browser", vim.log.levels.WARN)
    return
  end

  vim.fn.jobstart({ open_cmd, url }, { detach = true })
end

--- Notify user with consistent formatting
--- @param msg string Message to display
--- @param level number|nil Log level (default: INFO)
local function notify(msg, level)
  vim.notify(string.format("[LiveServer] %s", msg), level or vim.log.levels.INFO)
end

--- Start the live server
--- @param port number|nil Port number (default: 8080)
--- @param opts table|nil Options table { open = boolean }
function M.start(port, opts)
  if is_running() then
    notify(string.format("Already running at %s", get_url()), vim.log.levels.WARN)
    return false
  end

  opts = opts or {}
  state.port = port or state.port or 8080
  state.start_dir = vim.fn.getcwd()

  -- Try to start the server
  state.job_id = vim.fn.jobstart(
    { "python3", "-m", "http.server", tostring(state.port) },
    {
      cwd = state.start_dir,
      detach = true,
      on_stdout = function(_, data)
        if data and #data > 0 then
          for _, line in ipairs(data) do
            if line ~= "" then
              vim.schedule(function()
                vim.notify(string.format("[LiveServer] %s", line), vim.log.levels.DEBUG)
              end)
            end
          end
        end
      end,
      on_stderr = function(_, data)
        if data and #data > 0 then
          for _, line in ipairs(data) do
            if line ~= "" and not line:match("^%s*$") then
              vim.schedule(function()
                notify(line, vim.log.levels.ERROR)
              end)
            end
          end
        end
      end,
      on_exit = function(_, exit_code)
        vim.schedule(function()
          if exit_code ~= 0 and exit_code ~= 143 then -- 143 = SIGTERM (normal stop)
            notify(string.format("Server stopped unexpectedly (exit code: %d)", exit_code), vim.log.levels.ERROR)
          end
          state.job_id = nil
        end)
      end,
    }
  )

  if state.job_id <= 0 then
    notify("Failed to start server. Is Python 3 installed?", vim.log.levels.ERROR)
    state.job_id = nil
    return false
  end

  notify(string.format("Started at %s (serving: %s)", get_url(), state.start_dir))

  -- Open in browser if requested
  if opts.open then
    vim.defer_fn(function()
      open_in_browser(get_url())
    end, 500) -- Small delay to ensure server is ready
  end

  return true
end

--- Stop the live server
function M.stop()
  if not is_running() then
    notify("Server is not running", vim.log.levels.WARN)
    return false
  end

  vim.fn.jobstop(state.job_id)
  state.job_id = nil
  notify("Server stopped")
  return true
end

--- Toggle the live server on/off
--- @param port number|nil Port number (only used when starting)
--- @param opts table|nil Options table { open = boolean }
function M.toggle(port, opts)
  if is_running() then
    M.stop()
  else
    M.start(port, opts)
  end
end

--- Show server status
function M.status()
  if is_running() then
    notify(string.format("Running at %s (serving: %s)", get_url(), state.start_dir))
  else
    notify("Server is not running")
  end
end

--- Open server in browser
function M.open()
  if not is_running() then
    notify("Server is not running. Start it first with :LiveServerStart", vim.log.levels.WARN)
    return
  end
  open_in_browser(get_url())
  notify(string.format("Opening %s in browser", get_url()))
end

--- Setup commands and autocommands
--- @param opts table|nil Configuration options
---   - default_port: number (default: 8080)
---   - auto_open: boolean (default: false) - Open browser on start
function M.setup(opts)
  opts = opts or {}
  state.port = opts.default_port or 8080

  -- Create user commands
  vim.api.nvim_create_user_command("LiveServerStart", function(cmd_opts)
    local port = tonumber(cmd_opts.args) or state.port
    M.start(port, { open = opts.auto_open })
  end, {
    nargs = "?",
    desc = "Start live server (optional: specify port)",
  })

  vim.api.nvim_create_user_command("LiveServerStop", function()
    M.stop()
  end, {
    desc = "Stop live server",
  })

  vim.api.nvim_create_user_command("LiveServerToggle", function(cmd_opts)
    local port = tonumber(cmd_opts.args) or state.port
    M.toggle(port, { open = opts.auto_open })
  end, {
    nargs = "?",
    desc = "Toggle live server on/off",
  })

  vim.api.nvim_create_user_command("LiveServerStatus", function()
    M.status()
  end, {
    desc = "Show live server status",
  })

  vim.api.nvim_create_user_command("LiveServerOpen", function()
    M.open()
  end, {
    desc = "Open server in browser",
  })

  -- Stop server when exiting Neovim
  vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
      if is_running() then
        M.stop()
      end
    end,
    desc = "Stop live server on exit",
  })
end

return M
