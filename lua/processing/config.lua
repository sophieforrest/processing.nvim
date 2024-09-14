---@class processing.Config: processing.Opts
local M = {}

---@class processing.Opts
---@field test table

---@type processing.Opts
local defaults = {
    test = {}
}

---@type processing.Opts
M.opts = nil


---@param opts processing.Opts
function M.setup(opts)
    ---@type processing.Opts
    M.opts = vim.tbl_extend('force', defaults, opts or {})
end


return M
