local Commands = {}

---@class processing.Command.Subcommand
---@field impl fun(args:string[], opts: table) The command implementation
---@field complete? fun(subcmd_arg_lead: string): string[] (optional) Command completions callback, taking the lead of the subcommand's arguments

---@type table<string, processing.Command.Subcommand>
local subcommands = {}

--- Sorted subcommands by name.
---@type table<integer, string>
local subcommand_names = {}

--- Add a subcommand to the :Processing command.
---@param name string Subcommand name.
---@param subcommand processing.Command.Subcommand Subcommand implementation.
function Commands.add_subcommand(name, subcommand)
    subcommands = vim.tbl_extend('force', subcommands, {
        [name] = subcommand,
    })

    table.insert(subcommand_names, name)
    table.sort(subcommand_names)
end

--- Implementation for the :Processing command.
---@param opts table :h lua-guide-commands-create
local function processing_cmd(opts)
    local fargs = opts.fargs
    local subcommand_key = fargs[1]
    -- Get the subcommand's arguments, if any
    local args = #fargs > 1 and vim.list_slice(fargs, 2, #fargs) or {}
    local subcommand = subcommands[subcommand_key]
    if not subcommand then
        vim.notify(
            'Unknown command: ' .. subcommand_key,
            vim.log.levels.ERROR,
            { title = 'processing.nvim' }
        )
        return
    end

    -- Invoke the subcommand
    subcommand.impl(args, opts)
end

vim.api.nvim_create_user_command('Processing', processing_cmd, {
    nargs = '+',
    desc = 'processing.nvim root command.',
    complete = function(arg_lead, cmdline, _)
        -- Get the subcommand.
        local subcmd_key, subcmd_arg_lead = cmdline:match("^['<,'>]*Processing[!]*%s(%S+)%s(.*)$")
        if
            subcmd_key
            and subcmd_arg_lead
            and subcommands[subcmd_key]
            and subcommands[subcmd_key].complete
        then
            -- The subcommand has completions. Return them.
            return subcommands[subcmd_key].complete(subcmd_arg_lead)
        end
        -- Check if cmdline is a subcommand
        if cmdline:match("^['<,'>]*Processing[!]*%s+%w*$") then
            -- Filter subcommands that match
            return vim.iter(subcommand_names)
                :filter(function(key)
                    return key:find(arg_lead) ~= nil
                end)
                :totable()
        end
    end,
})

return Commands
