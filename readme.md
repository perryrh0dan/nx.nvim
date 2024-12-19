# nx.nvim

NX workspace plugin for neovim

## Installation & Usage

```lua
require('lazy').setup({
   "perryrh0dan/nx.nvim'
})
```

### Keymaps

Get the project name of the current open file

```lua
vim.api.nvim_create_user_command('NxProjectName', function()
    local filepath = vim.fn.expand('%')
    local name = require('custom.utils.nx').projectName(filepath)
    vim.fn.setreg('+', name) -- write to clippoard
    vim.print(name)
end, { desc = 'Copy NX Project Name' })
```

```lua
vim.api.nvim_create_user_command('NxProjectTarget', function()
    local filepath = vim.fn.expand('%')
    local target = require('nx').projectTarget(filepath)
    if target ~= nil then
        vim.fn.setreg('+', target) -- write to clippoard
        vim.schedule(function()
            vim.notify(target)
        end)
    end
end, { desc = 'Select and copy NX project target' })

```

## Dependencies

This plugin requires `jq` to parse the project.json
