if not vim.g.loaded_processing_nvim then
    local config = require('processing.config')
    -- Load processing.nvim commands
    local commands = require('processing.commands')

    if vim.fn.executable('ctags') then
        commands.add_subcommand('ctags', {
            complete = function(_)
                return {}
            end,
            impl = function(_, _)
                -- TODO: We should report an error if this fails.
                vim.system({ 'ctags', '--langmap=java:+.pde', '-R' })
            end,
        })
    end

    if config.highlight.enable then
        -- Register the Java parser as the Processing parser
        vim.treesitter.language.register('java', 'processing')
    end

    if config.lsp.cmd ~= nil then
        local processing = vim.api.nvim_create_augroup('ProcessingNvim', {
            clear = false,
        })
        vim.api.nvim_create_autocmd({ 'BufReadPost' }, {
            callback = function()
                require('processing.lsp').start()
            end,
            desc = 'Start processing-lsp on BufReadPost.',
            group = processing,
            pattern = { '*.pde' },
        })

        -- Run the initial BufReadPost, as this won't occur on the first buffer
        vim.api.nvim_exec_autocmds({ 'BufReadPost' }, {
            buffer = vim.api.nvim_get_current_buf(),
            group = processing,
        })
    end
end

vim.g.loaded_processing_nvim = true

-- Set commentstring for Processing files
vim.bo.commentstring = '// %s'
