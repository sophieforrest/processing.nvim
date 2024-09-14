---@mod processing.config.check processing.nvim configuration validation.
---
---@brief [[
---
--- rest.nvim config validation (internal)
---
---@brief ]]

local Check = {}

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
---
---Validates the processing.nvim configuration.
---@param config processing.Config
---@return boolean is_valid
---@return string? error_message
function Check.validate(config)
    local ok, err = validate({
        highlight = { config.highlight, "table" },
        ["highlight.enable"] = { config.highlight.enable, "boolean" },
        lsp = { config.lsp, "table" },
        ["lsp.cmd"] = { config.lsp.cmd, { "table", "function", "nil" } },
    })

    if not ok then
        return false, err
    end
    return true
end

return Check
