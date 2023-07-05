return {
    'ibhagwan/fzf-lua',
    dependencies = {
        {'kyazdani42/nvim-web-devicons'},
        {'junegunn/fzf', build = './install --bin'}
    },
    config = function ()
        local function find_git_root()
            local dot_git_path = vim.fn.finddir(".git", ".;")
            return vim.fn.fnamemodify(dot_git_path, ":h")
        end

        -- for fzf.vim
        -- vim.fn['fzf#vim#files'](get_git_root())
        -- vim.keymap.set('n', '<leader>ff', function () return vim.fn['fzf#vim#files'](find_git_root()) end, {expr = true})
        -- vim.keymap.set('n', '<leader>fg', ':Rg<cr>')
        -- vim.keymap.set('n', '<leader>fa', function () return vim.fn['fzf#vim#files']('~') end, {expr = true})
        -- vim.keymap.set('n', '<leader>fh', ':Helptags<cr>')

        -- for fzf-lua
        local fzf = require('fzf-lua')
        fzf.setup {
            files = {git_icons = false, file_icons = false},
        }
        vim.keymap.set(
            'n', '<leader>ff', function() return fzf.files({cwd = find_git_root()}) end)
        vim.keymap.set('n', '<leader>fg', fzf.grep_project)
        vim.keymap.set('n', '<leader>fh', fzf.help_tags)
        vim.keymap.set(
            'n', '<leader>fn', function() return fzf.files({cwd = '~/.config/nvim'}) end)
        vim.keymap.set(
            'n', '<leader>fa', function() return fzf.files({cwd = '~'}) end)
    end,
}
