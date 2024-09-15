# processing.nvim

A simple plugin that provides [Processing](https://processing.org/) support for [Neovim](https://neovim.io/).

## Features

1. Processing ctags generates an index file of symbols in your source code,
   enabling quick navigation to definitions and declarations directly within
   your editor.

2. The `:make` command in Neovim is configured to execute your Processing
   sketch directly using processing-java --sketch=/path/to/your/sketch --run

3. The `:Processing lsp` command starts the Processing Language Server (LSP),
   which must be manually set up. if `vim.g.processing_nvim.lsp.cmd` is nil,
   the LSP will not start.

4. The commentstring is set to `// %s` to format comments in a way that matches
   the style used in Java, where `//` is used for single-line comments.

## Requirements

- Neovim >= 0.10.0 (may work on previous versions).
- Processing IDE (MacOSX users will need to install the processing command from
  the IDE)
  - Location: Menu Bar > Tools > Install "processing-java"
- Optional:
  - [ctags](https://github.com/universal-ctags/ctags) (for `:Processing ctags`).
  - a Processing Language Server (for lsp setup and `:Processing lsp`).
  - [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) with
    the [tree-sitter-java](https://github.com/tree-sitter/tree-sitter-java)
    parser for syntax highlighting.

## Installation

Install processing.nvim with a plugin manager of your choice

### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
    'sophieforrest/processing.nvim'
    -- This plugin is already lazy-loaded.
    lazy = false,
}
```

### [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use 'sophieforrest/processing.nvim'
```

### [paq-nvim](https://github.com/savq/paq-nvim)

```lua
'sophieforrest/processing.nvim'
```

### [vim-plug](https://github.com/savq/paq-nvim)

```vim
Plug 'sophieforrest/processing.nvim'
```

## Configuration

> [!important]
> Make sure to run `:checkhealth processing` if something isn't working properly

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
        -- manually as processing doesn't bundle their LSP as a separate package.
        -- This generally involves editing the processing wrapper script.
        -- This will not start the LSP if set to nil.
        cmd = nil,
        -- Example: cmd = { "processing-lsp" }
    },
}
```

To add configurations, users should place `vim.g.processing_nvim` in their
init.lua, or any file that is sourced by init.lua

## Recipes

Code examples that users of processing.nvim may find useful to include in their configs.

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

## Related projects

- [sophacles/vim-processing](https://github.com/sophacles/vim-processing)
