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
        vim.keymap.set('n', '<leader>xl', '<plug>(vimtex-compile)')
        vim.keymap.set('n', '<leader>xx', '<plug>(vimtex-stop)')
        vim.keymap.set('n', '<leader>xc', '<plug>(vimtex-clean)')
        vim.keymap.set('n', '<leader>xC', '<plug>(vimtex-clean-full)')
        vim.keymap.set('n', '<leader>xe', '<plug>(vimtex-errors)')

        local function view_zathura()
            local fname = vim.fn.expand('%:r') .. '.pdf'
            local cmd = '!zathura ' .. fname
            vim.api.nvim_command(cmd)
        end
        vim.keymap.set('n', '<leader>xv', view_zathura)
    end,
}
