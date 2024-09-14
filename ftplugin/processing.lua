if not vim.g.loaded_processing_nvim then
    local config = require('processing.config')

    if config.highlight.enable then
        -- Register the Java parser as the Processing parser
        vim.treesitter.language.register('java', 'processing')
    end
end

vim.g.loaded_processing_nvim = true

-- Set commentstring for Processing files
vim.bo.commentstring = '// %s'
