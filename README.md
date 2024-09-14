# processing.nvim

A simple plugin that provides [Processing](https://processing.org/) support for [Neovim](https://neovim.io/).

## NOTE

This plugin is still work in progress, and doesn't support all the features of
[sophacles/vim-processing](https://github.com/sophacles/vim-processing). However,
it is still usable as long as you don't need the `:make` functionality.

## Requirements

- Neovim >= 0.10.0 (may work on previous versions).
- optional:
  - [ctags](https://github.com/universal-ctags/ctags) (for `:Processing ctags`).
  - a Processing Language Server (for lsp setup and `:Processing lsp`).
  - [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) with
    the [tree-sitter-java](https://github.com/tree-sitter/tree-sitter-java)
    parser for syntax highlighting.

## Installation

processing.nvim supports all the usual plugin managers.

### lazy.nvim

```lua
{
    'sophieforrest/processing.nvim'
    -- This plugin is already lazy-loaded.
    lazy = false,
}
```

### Packer

```lua
require("packer").startup(function()
    use({ 'sophieforrest/processing.nvim' })
end,
```

### Paq

```lua
require("paq")({
    { 'sophieforrest/processing.nvim' }
})
```

### vim-plug

```vim
Plug 'sophieforrest/processing.nvim'
```

### dein

```vim
call dein#add('sophieforrest/processing.nvim')
```

### Pathogen

```sh
git clone --depth=1 https://github.com/sophieforrest/processing.nvim.git ~/.vim/bundle
```

### Neovim native package

```sh
git clone --depth=1 https://github.com/sophieforrest/processing.nvim.git \
    "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/pack/processing/start/processing.nvim
```

## Configuration

processing.nvim uses the `vim.g.processing_nvim` namespace for configuration.
The default configuration can be found below.

```lua
vim.g.processing_nvim = {
    highlight = {
        -- Whether to enable treesitter highlighting.
        enable = true,
    },
    lsp = {
        -- The command to use for processing-lsp. This needs to be created
        -- manually as processing doesn't bundle their LSP as a separate
        -- package. This generally involves editing the processing wrapper
        -- script.
        --
        -- This will not start the LSP if set to nil.
        cmd = nil,

        -- Example
        -- cmd = { "processing-lsp" }
    },
}
```

## Recipes

Snippets users of processing.nvim may find useful to include in their configs.

### Generating ctags on save

```lua
local processing_ctags = vim.api.nvim_create_augroup('ProcessingCtags', {})
vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
    command = 'Processing ctags',
    desc = 'Generate ctags for Processing on save.',
    group = processing_ctags,
    pattern = { '*.pde' },
})
```

## Roadmap

Plugin roadmap. If you have anything you feel should be added, please open an issue.

- [x] `:Processing ctags`
- [ ] `:make` runs sketch
- [x] Language Server
  - [x] Start Processing LSP
  - [x] `:Processing lsp`
- [x] Set commentstring

## Related projects

- [sophacles/vim-processing](https://github.com/sophacles/vim-processing)
