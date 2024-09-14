---@class processing.Config
local default_config = {
    ---@class processing.Config.Highlight
    highlight = {
        ---@type boolean Whether to enable treesitter highlighting with processing.
        enable = true,
    },
    ---@class processing.Config.Lsp
    lsp = {
        ---@type string[]|nil|fun(dispatchers: vim.lsp.rpc.Dispatchers): vim.lsp.rpc.PublicClient Command to run for the Processing LSP. Will not run if option is not specified.
        cmd = nil,
    },
}

return default_config
