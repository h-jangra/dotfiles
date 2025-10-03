
local M = {}

local job_id = nil

-- Start live server
function M.start()
  if job_id ~= nil then
    print("Live Server already running at http://localhost:8080/")
    return
  end

  job_id = vim.fn.jobstart(
    { "python3", "-m", "http.server", "8080" },
    {
      cwd = vim.fn.getcwd(),
      detach = true,
      on_exit = function()
        job_id = nil
      end,
    }
  )

  if job_id > 0 then
    print("Live Server started at http://localhost:8080/")
  else
    print("Failed to start Live Server")
    job_id = nil
  end
end

-- Stop live server
function M.stop()
  if job_id == nil then
    return
  end

  vim.fn.jobstop(job_id)
  job_id = nil
  print("Live Server stopped")
end

-- Setup commands + autocmd
function M.setup()
  vim.api.nvim_create_user_command("LiveServerStart", function()
    M.start()
  end, {})

  vim.api.nvim_create_user_command("LiveServerStop", function()
    M.stop()
  end, {})

  -- Stop server when exiting Neovim
  vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
      M.stop()
    end,
  })
end

return M
