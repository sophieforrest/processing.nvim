if not vim.g.loaded_processing_nvim then
    -- Load processing.nvim commands
    require('processing.commands')

    local config = require('processing.config')

    if config.highlight.enable then
        -- Register the Java parser as the Processing parser
        vim.treesitter.language.register('java', 'processing')
    end

    if config.lsp.cmd ~= nil then
        local processing = vim.api.nvim_create_augroup('ProcessingNvim', {
            clear = false,
        })
        vim.api.nvim_create_autocmd({ 'BufEnter' }, {
            callback = function()
                require('processing.lsp').start()
            end,
            desc = 'Start processing-lsp on BufEnter.',
            group = processing,
            pattern = { '*.pde' },
        })
    end
end

vim.g.loaded_processing_nvim = true

-- Set commentstring for Processing files
vim.bo.commentstring = '// %s'
