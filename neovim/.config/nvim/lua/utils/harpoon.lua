local M = {}

local harpoon = require('harpoon')
local project = require('utils.project')


M.curr_branch_list = nil

-- maintain a list of current marks instead?
function M.update_current_list()
    M.curr_branch_list = project.get_git_branch()

    -- local name = nil
    -- local proj_root = project.get_root()
    -- if proj_root then
    --     local branch = project.get_git_branch()
    --     local proj_name = proj_root:match("/([^/]+)$")
    --     name = proj_name .. ':' .. branch
    -- end
    -- M.curr_proj_list = name
end


function M.toggle(list_name)
    local harp_list = harpoon:list(list_name)
    local fname = vim.fn.expand('%')
    local item = harp_list:get_by_value(fname)
    if item ~= nil then
        harp_list:remove(item)
    else
        harp_list:add()
    end
end

M.update_current_list()

return M
