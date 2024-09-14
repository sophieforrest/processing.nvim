---Validates the plugin configuration.
---@param tbl table The table to validate
---@see vim.validate
---@return boolean is_valid
---@return string? error_message
local function validate(tbl)
    local prefix = "Invalid config: "
    local ok, err = pcall(vim.validate, tbl)
    return ok or false, err and (prefix .. err) or nil
end
