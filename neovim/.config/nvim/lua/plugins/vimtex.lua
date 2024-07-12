return {
    'lervag/vimtex',
    init = function()
        vim.g.tex_flavor = 'latex'
        vim.g.vimtex_enabled = 1
        vim.g.vimtex_mappings_enabled = 1
        vim.g.vimtex_text_obj_variant = "vimtex"
        vim.g.vimtex_view_method = "zathura"
        vim.g.vimtex_compiler_latexmk = { continuous = 0 }
    end,
    config = function()
        vim.keymap.set('n', '<leader>ll', '<plug>(vimtex-compile)')
        vim.keymap.set('n', '<leader>lx', '<plug>(vimtex-stop)')
        vim.keymap.set('n', '<leader>lc', '<plug>(vimtex-clean)')
        vim.keymap.set('n', '<leader>lC', '<plug>(vimtex-clean-full)')
        vim.keymap.set('n', '<leader>le', '<plug>(vimtex-errors)')

        local function view_zathura()
            local fname = vim.fn.expand('%:r') .. '.pdf'
            local cmd = '!zathura ' .. fname
            vim.api.nvim_command(cmd)
        end
        vim.keymap.set('n', '<leader>lv', view_zathura)
    end,
}
