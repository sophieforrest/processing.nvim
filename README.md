# processing.nvim

A simple plugin that provides [Processing](https://processing.org/) support for [Neovim](https://neovim.io/).

## NOTE

This plugin is still work in progress, and doesn't support all the features of
[sophacles/vim-processing](https://github.com/sophacles/vim-processing). However,
it is still usable as long as you don't need the `:make` functionality.

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

## Related projects

- [sophacles/vim-processing](https://github.com/sophacles/vim-processing)
