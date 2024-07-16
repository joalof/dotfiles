-- Utility module for things related to project management
local M = {}


M.root_identifiers = {".git", "Project.toml", "setup.py", "pyproject.toml"}


function M.get_git_branch()
    local obj = vim.system({'sh', '-c', 'git branch --show-current'}, {})
    local res = obj:wait()
    return res.stdout:sub(1, #res.stdout - 1)
end


function M.get_root(fallback)
    local home = vim.uv.os_homedir()
    for _, name in ipairs(M.root_identifiers) do
        local res = vim.fs.find({name}, {upward=true, stop=home})
        if #res > 0 then
            local id_path = res[1]
            local root_dir = id_path:sub(1, #id_path - #name - 1)
            return root_dir
        else
            if fallback == 'cwd' then
                return vim.uv.cwd()
            elseif fallback == 'home' or fallback == '~' then
                return home
            else
                return fallback()
            end
        end
    end
end


return M
