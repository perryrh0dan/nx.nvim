# nx.nvim

NX workspace plugin for neovim

## Installation & Usage

```lua
require('lazy').setup({
   "perryrh0dan/nx.nvim'
})
```

### Usage

Copy the project name of the current open file

```lua
vim.api.nvim_create_user_command('NxProjectName', function()
    local filepath = vim.fn.expand('%')
    local name = require('custom.utils.nx').projectName(filepath)
    vim.fn.setreg('+', name) -- write to clippoard
    vim.print(name)
end, { desc = 'Copy NX project name' })
```

Select and copy a target for the current project to paste it directly into the terminal

```lua
vim.api.nvim_create_user_command('NxProjectTarget', function()
    local filepath = vim.fn.expand('%')
    local target = require('nx').projectTarget(filepath)
    if target ~= nil then
        local command = 'npx nx run ' .. target
        vim.fn.setreg('+', command) -- write to clippoard
        -- Without vim.schedule the select will not be properly "closed" and is still visible on the screen
        vim.schedule(function()
            vim.notify(command)
        end)
    end
end, { desc = 'Select and copy NX project target' })

```

## Dependencies

This plugin requires `jq` to parse the project.json
