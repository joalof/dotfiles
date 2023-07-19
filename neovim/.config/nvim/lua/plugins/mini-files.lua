return {
    'echasnovski/mini.files',
    version = false,
    event = 'VeryLazy',
    
    config = function()
        local mini_files = require('mini.files')
        mini_files.setup()

        -- change directories somehow
        -- local files_set_cwd = function(path)
        --     -- Works only if cursor is on the valid file system entry
        --     local cur_entry_path = mini_files.get_fs_entry().path
        --     local cur_directory = vim.fs.dirname(cur_entry_path)
        --     vim.fn.chdir(cur_directory)
        -- end
        -- vim.api.nvim_create_autocmd('User', {
        --     pattern = 'MiniFilesBufferCreate',
        --     callback = function(args)
        --         vim.keymap.set('n', '<leader>cd', files_set_cwd, { buffer = args.data.buf_id })
        --     end,
        -- })

        vim.keymap.set('n', '<leader>fe', require('mini.files').open)
    end,
}
