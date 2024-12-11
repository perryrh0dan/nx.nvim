local M = {}

local get_parent_dir = function(path)
    path = path:gsub("/$", "")
    local t = path:match(".*/")

    return t
end

local scandir = function(directory)
    local i, t, popen = 0, {}, io.popen
    local pfile = popen('ls -a "' .. directory .. '"')
    for filename in pfile:lines() do
        i = i + 1
        t[i] = filename
    end
    pfile:close()
    return t
end

local function find_file(directory)
    local files = scandir(directory)
    for _i, file in ipairs(files) do
        if file == "project.json" then
            return directory .. file
        end
    end

    if directory ~= '/' then
        local parent = get_parent_dir(directory)
        if parent ~= nil then
            return find_file(parent)
        else
            return nil
        end
    else
        return nil
    end
end

local function read_file(file)
    local i, t, popen = 0, {}, io.popen
    local pfile = popen('cat  "' .. file .. '" | jq -r ".name" | head -n 1')
    local result = ""
    for line in pfile:lines() do
        result = line
    end

    return result
end

M.projectName = function(path)
    local parentDir = get_parent_dir(path)

    local file = find_file(parentDir)
    if file == nil then
        return nil
    end

    local name = read_file(file)

    return name
end

return M
