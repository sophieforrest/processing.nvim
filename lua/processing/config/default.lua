---@mod processing.config.default Default processing.nvim configuration.

---@class processing.Config: processing.Opts
---@field highlight processing.Config.Highlight
---@field lsp processing.Config.Lsp

---@class processing.Config.Highlight
---@field enable boolean

---@class processing.Config.Lsp
---@field cmd string[]|nil|fun(dispatchers: vim.lsp.rpc.Dispatchers): vim.lsp.rpc.PublicClient

---@class processing.Config: processing.Opts
local Default = {}

---@type processing.Config
Default.default_config = {
    highlight = {
        ---@type boolean
        enable = true,
    },
    lsp = {
        ---@type string[]|nil|fun(dispatchers: vim.lsp.rpc.Dispatchers): vim.lsp.rpc.PublicClient
        cmd = nil,
    },
}

return Default
