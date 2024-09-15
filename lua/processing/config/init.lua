---@mod processing.config processing.nvim configuration.
---
---@brief [[
---
--- processing.nvim configuration options.
---
--- You can set processing.nvim configuration options via `vim.g.processing_nvim`.
---
---@endbrief

---@class processing.Config: processing.Opts

---@tag vim.g.processing_nvim
---@tag g:processing_nvim
---@class processing.Opts
---@field highlight? processing.Opts.Highlight Syntax highlighting options.
---@field lsp? processing.Opts.Lsp Command to run to execute the processing language server.

---@class processing.Opts.Highlight
---@field enable? boolean Whether to enable treesitter highlighting with processing.

---@class processing.Opts.Lsp
---@field cmd? string[]|fun(dispatchers: vim.lsp.rpc.Dispatchers): vim.lsp.rpc.PublicClient Command to run for the Processing LSP. Will not run if option is not specified.

---@type processing.Opts
vim.g.processing_nvim = vim.g.processing_nvim

local check = require('processing.config.check')
local default_config = require('processing.config.default').default_config
local opts = vim.g.processing_nvim or {}

---@type processing.Config
local config = vim.tbl_extend('force', default_config, opts)

local ok, err = check.validate(config)

if not ok then
    ---@cast err string
    vim.notify(err, vim.log.levels.ERROR, { title = 'processing.nvim' })
end

return config
