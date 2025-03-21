local M = {}

local get_parent_dir = function(path)
    if path == './' then
        return nil
    end

    path = path:gsub("/$", "")
    local t = path:match(".*/")

    if t == nil then
        return './'
    end

    return t
end

local scandir = function(directory)
    if directory == nil then
        return {}
    end
    local i, t, popen = 0, {}, io.popen
    local pfile, error = popen('ls -a "' .. directory .. '" 2>/dev/null')
    for filename in pfile:lines() do
        i = i + 1
        t[i] = filename
    end
    pfile:close()
    return t
end

local function find_file(directory, filename)
    local files = scandir(directory)
    for _i, file in ipairs(files) do
        if string.match(file, filename) then
            return directory .. file
        end
    end

    if directory ~= '/' then
        local parent = get_parent_dir(directory)
        if parent ~= nil then
            return find_file(parent, filename)
        else
            return nil
        end
    else
        return nil
    end
end

local function read_file(file, path)
    local i, t, popen = 0, {}, io.popen
    local pfile = popen('cat  "' .. file .. '" | jq -r "' .. path .. '"')
    local result = {}
    for line in pfile:lines() do
        table.insert(result, line)
    end

    return result
end

local function select_option(prompt, options)
    return coroutine.wrap(function()
        vim.ui.select(options, { prompt = prompt }, function(choice)
            coroutine.yield(choice)
        end)
    end)()
end

M.project_name = function(path)
    local parentDir = get_parent_dir(path)

    local file = find_file(parentDir, "project.json")
    if file == nil then
        return nil
    end

    local result = read_file(file, '.name')

    return result[1]
end

M.project_target = function(path)
    local parentDir = get_parent_dir(path)

    local file = find_file(parentDir, "project.json")
    if file == nil then
        return nil
    end
    local name = read_file(file, '.name')[1]
    local options = read_file(file, '.targets | keys | .[]')

    local target = select_option('Select target:', options)
    if target == nil then
        return nil
    end
    return name .. ":" .. target
end

M.workspace_generator = function(path)
    local parentDir = get_parent_dir(path)

    local file = find_file(parentDir, "nx.json")
    if file == nil then
        return nil
    end

    local generators = read_file(file, '.generators | keys | .[]')
    local generator = select_option('Select generator:', generators)
    if generator == nil then
        return nil
    end
    return generator
end

return M
