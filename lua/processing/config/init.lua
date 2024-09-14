---@mod processing.config processing.nvim configuration.
---
---@brief [[
---
--- processing.nvim configuration options.
---
--- You can set processing.nvim configuration options via `vim.g.processing_nvim`.
---
--->lua
--- ---@type processing.Opts
--- vim.g.processing_nvim
---<
---
---@brief ]]

---@class processing.Config
local config

---@type processing.Opts
vim.g.processing_nvim = vim.g.processing_nvim

vim.g.processing_nvim = vim.g.processing_nvim or {}

---@tag vim.g.processing_nvim
---@tag g:processing_nvim
---@class processing.Opts
---@field processing_ls_command string? Command to run to execute the processing language server.

return config
