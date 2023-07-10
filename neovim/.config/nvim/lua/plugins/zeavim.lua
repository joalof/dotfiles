return {
    'KabbAmine/zeavim.vim',
    event = 'VeryLazy',
    init = function()
        vim.g.zv_disable_mapping = 1
    end,
    config = function ()
        vim.keymap.set('n', '<leader>K', '<Plug>Zeavim')
        vim.keymap.set('n', 'gk', '<Plug>ZVOperator')
        vim.keymap.set('v', '<leader>K', '<Plug>ZVVisSelection')
        vim.keymap.set('n', '<leader>kd', '<Plug>ZVKeyDocset')
        vim.g.zv_file_types = {
            python = "numpy,scipy,matplotlib,pandas,python3"
        }
    end,
}
