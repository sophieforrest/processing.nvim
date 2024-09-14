---@class processing
local M = {}

---@param opts processing.Opts
function M.setup(opts)
    require'processing.config'.setup(opts)
end

return M
