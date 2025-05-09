-- Utility module for things related to project management
local M = {}

M.root_identifiers = { ".git" }

function M.get_git_branch()
    local obj = vim.system({ "sh", "-c", "git branch --show-current" }, {})
    local res = obj:wait()
    return res.stdout:sub(1, #res.stdout - 1)
end

function M.setup_root_caching(fallback)
    local augroup = vim.api.nvim_create_augroup("Project", { clear = true })
    vim.api.nvim_create_autocmd("DirChanged", {
        group = augroup,
        callback = function()
            vim.g.project_root = M.get_root(fallback)
        end,
    })
    vim.g.project_root = M.get_root(fallback)
end

function M.get_root(fallback)
    local home = vim.uv.os_homedir()
    local root_dir = nil
    for _, name in ipairs(M.root_identifiers) do
        local res = vim.fs.find({ name }, { upward = true, stop = home })
        if #res > 0 then
            local id_path = res[1]
            root_dir = id_path:sub(1, #id_path - #name - 1)
            M.cached_root = root_dir
            return root_dir
        end
    end

    if fallback == "cwd" then
        root_dir = vim.uv.cwd()
    elseif fallback == "home" or fallback == "~" then
        root_dir = home
    else
        root_dir = fallback()
    end
    return root_dir
end

return M
