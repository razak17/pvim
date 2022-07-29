local status_ok, _ = pcall(vim.cmd, "colorscheme zephyr")
if not status_ok then
  -- vim.notify("colorscheme " .. colorscheme .. " not found!")
  return
end
