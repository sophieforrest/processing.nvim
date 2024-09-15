describe('external tools', function()
    it('should be able to run ctags', function()
        assert.are.equal(vim.fn.executable('ctags'), 1)
    end)

    it('should be able to run processing-lsp', function()
        assert.are.equal(vim.fn.executable('processing-lsp'), 1)
    end)
end)
