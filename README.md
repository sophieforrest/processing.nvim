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
- processing-java
- Optional:
  - [ctags](https://github.com/universal-ctags/ctags) (for `:Processing ctags`).
  - a Processing Language Server (for lsp setup and `:Processing lsp`).
  - [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) with
    the [tree-sitter-java](https://github.com/tree-sitter/tree-sitter-java)
    parser for syntax highlighting.

> [!warning]
> macOS users will need to install the processing-java command from the IDE.
> The `:make` command will not function without doing this.
> Location: Menu Bar > Tools > Install "processing-java"

## Installation

  Install processing.nvim with a package manager of your choice.

### [rocks.nvim](https://github.com/nvim-neorocks/rocks.nvim)

```vim
:Rocks install processing.nvim
```

### [lazy.nvim](https://github.com/folke/lazy.nvim)

  ```lua
{
  'sophieforrest/processing.nvim'
  -- This plugin is already lazy-loaded.
  lazy = false,
  -- Recommended.
  version = "^1",
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

### [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'sophieforrest/processing.nvim'
```

## Configuration

> [!important]
> If the plugin isn't working correctly, run `:checkhealth processing` to
> identify possible issues.

processing.nvim uses the `vim.g.processing_nvim` namespace for configuration.
The default configuration can be found below.

```lua
vim.g.processing_nvim = {
  ---@type processing.Config
  Default.default = {
    highlight = {
      -- Whether to enable treesitter highlighting.
        ---@type boolean
        enable = true,
    },
    lsp = {
      -- The command to use for processing-lsp. This needs to be created
      -- manually as processing doesn't bundle their LSP as a separate package.
      -- This generally involves editing the processing wrapper script.
      -- This will not start the LSP if set to nil.
      ---@type string[]|nil|fun(dispatchers: vim.lsp.rpc.Dispatchers): vim.lsp.rpc.PublicClient
      cmd = nil,
      -- Example: cmd = { "processing-lsp" }
    },
  },
}
```

## Recipes

Code examples that users of processing.nvim may find useful to include in their configs.
These can be included anywhere in your configuration.

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

### Show errors when calling :make

```lua
vim.api.nvim_create_autocmd('QuickFixCmdPost', {
  pattern = '*',
  callback = function()
    if #vim.fn.getqflist() > 0 then
      vim.cmd('copen')
    end
  end,
})
```

## Related projects

- [sophacles/vim-processing](https://github.com/sophacles/vim-processing)
