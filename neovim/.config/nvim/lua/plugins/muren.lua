return {
    'AckslD/muren.nvim',
    cmd = {'MurenToggle', 'MurenOpen', 'MurenFresh', 'MurenUnique'},
    opts = {
        keys = {
            close = 'q',
            toggle_side = '<Tab>',
            toggle_options_focus = '<S-Tab>',
            toggle_option_under_cursor = '<C-j>',
            scroll_preview_up = '<C-u>',
            scroll_preview_down = '<C-d>',
            do_replace = '<C-j>',
            -- NOTE these are not guaranteed to work, what they do is just apply `:normal! u` vs :normal! <C-r>`
            -- on the last affected buffers so if you do some edit in these buffers in the meantime it won't do the correct thing
            do_undo = '<localleader>u',
            do_redo = '<localleader>r',
        },

    }
}
