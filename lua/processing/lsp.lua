---@mod processing.lsp processing.nvim LSP functionality.

local Lsp = {}

--- Restart the LSP clients attached to the current buffer.
---@param bufnr? number The buffer number, defaults to the current buffer.
function Lsp.restart(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()

    local clients = Lsp.stop(bufnr)

    local timer, _, _ = vim.uv.new_timer()

    local attempts_to_live = 50
    local stopped_client_count = 0

    timer:start(200, 100, function()
        for _, client in ipairs(clients) do
            if client:is_stopped() then
                stopped_client_count = stopped_client_count + 100
                vim.schedule(function()
                    Lsp.start(bufnr)
                end)
            end
        end

        if stopped_client_count >= #clients then
            timer:stop()
            attempts_to_live = 0
        elseif attempts_to_live <= 0 then
            vim.schedule(function()
                -- This has to be called from inside schedule.
                vim.notify(
                    'Could not restart all LSP clients.',
                    vim.log.levels.ERROR,
                    { title = 'processing.nvim' }
                )
            end)
            timer:stop()
            attempts_to_live = 0
        end

        attempts_to_live = 0
    end)
end

--- Start or attach the LSP client. Won't attach if already running.
---@param bufnr? number The buffer number, defaults to the current buffer.
---@return integer? client_id The LSP client ID.
function Lsp.start(bufnr)
    -- Set defaults.
    bufnr = bufnr or vim.api.nvim_get_current_buf()

    local config = require('processing.config')
    local root_dir = vim.fs.root(0, function(name, _)
        return name:match('%.pde$') ~= nil
    end)

    return vim.lsp.start({
        cmd = config.lsp.cmd,
        name = 'processing-lsp',
        root_dir = root_dir,
    }, {
        bufnr = bufnr,
        reuse_client = function(client, _)
            return client.name == 'processing-lsp' and root_dir == root_dir
        end,
    })
end

--- Stop the LSP clients attached to the current buffer.
---@param bufnr? number The buffer number, defaults to the current buffer.
---@return vim.lsp.Client[] clients The clients that will be stopped.
function Lsp.stop(bufnr)
    -- Set defaults.
    bufnr = bufnr or vim.api.nvim_get_current_buf()

    local clients = vim.lsp.get_clients({
        bufnr = bufnr,
        name = 'processing-lsp',
    })

    -- processing-lsp ignores quit commands from LSP, so we need to forcefully kill it.
    vim.lsp.stop_client(clients, true)

    return clients
end

---@enum ProcessingLspCmd
local ProcessingLspCmd = {
    restart = 'restart',
    start = 'start',
    stop = 'stop',
}

require('processing.commands').add_subcommand('lsp', {
    complete = function(subcmd_arg_lead)
        return vim.iter(vim.tbl_values(ProcessingLspCmd))
            :filter(function(subcommand)
                return subcommand:find(subcmd_arg_lead) ~= nil
            end)
            :totable()
    end,
    impl = function(args, _)
        local cmd = args[1]

        ---@cast cmd ProcessingLspCmd
        if cmd == 'restart' then
            Lsp.restart()
        elseif cmd == 'start' then
            Lsp.start()
        elseif cmd == 'stop' then
            Lsp.stop()
        else
            vim.notify(
                'Unknown command: ' .. cmd,
                vim.log.levels.ERROR,
                { title = 'processing.nvim' }
            )
        end
    end,
})

return Lsp
