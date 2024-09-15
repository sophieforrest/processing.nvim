local Health = {}

---@class processing.Health.Dependency
---@field command string Command for running this dependency.
---@field optional boolean Whether this dependency is required.
---@field required_by string Namespace this dependency is required by.

---@type table<integer, processing.Health.Dependency>
local dependencies = {
    {
        command = 'ctags',
        optional = true,
        required_by = 'Processing ctags',
    },
}

--- Run an executable check for a dependency.
---@param dependency processing.Health.Dependency Dependency to check against.
local function check_executable(dependency)
    local reporter = dependency.optional and vim.health.warn or vim.health.error

    if vim.fn.executable(dependency.command) then
        local handle = io.popen(dependency.command .. ' --version')
        if handle then
            local binary_version, error_msg = handle:read('*a')
            handle:close()
            if error_msg then
                reporter(
                    'not executable: '
                        .. dependency.command('. Required by ')
                        .. dependency.required_by
                        .. ' command.'
                )
            else
                vim.health.ok(dependency.command .. ' ' .. binary_version)
            end
        else
            vim.health.ok(dependency.command .. ' ' .. 'unknown version')
        end
    end
end

--- Check for the tree-sitter-java parser.
local function check_tree_sitter()
    local has_tree_sitter_rust_parser = #vim.api.nvim_get_runtime_file('parser/java.so', true) > 0
        or #vim.api.nvim_get_runtime_file('parser/java.dll', true) > 0
    if has_tree_sitter_rust_parser then
        vim.health.ok('tree-sitter parser for Java detected.')
    else
        vim.health.warn(
            'No tree-sitter parser for Java detected. Required by processing.highlight.'
        )
    end
end

--- Check the health of processing.nvim.
function Health.check()
    vim.health.start('tree-sitter parsers')
    check_tree_sitter()

    vim.health.start('External tools')
    check_executable(dependencies[1])
end

return Health
