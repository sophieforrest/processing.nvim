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

---@type processing.Config
local config

---@type processing.Config
vim.g.processing_nvim = vim.g.processing_nvim

local default_config = require("processing.config.default")
local opts = vim.g.processing_nvim or {}

config = vim.tbl_deep_extend("force", {}, default_config, opts)

---@tag vim.g.processing_nvim
---@tag g:processing_nvim
---@class processing.Config
---@field processing_ls_command string? Command to run to execute the processing language server.

return config
