return {
    'nvim-pack/nvim-spectre',
    keys = { "<leader>as" },
    config = function()
        vim.keymap.set(
            'n',
            '<leader>as',
            function()
                require('spectre').open()
                require('spectre').change_view()
            end
        )
        require('spectre').setup(
            {
                default = {
                    replace = {
                        cmd = "sed",
                    },
                },
                live_update = true,
                mapping = {
                    ['enter_file'] = {
                        map = "<c-l>",
                        cmd = "<cmd>lua require('spectre.actions').select_entry()<CR>",
                        desc = "open file"
                    },
                    ['run_replace'] = {
                        map = "<c-y>",
                        cmd = "<cmd>lua require('spectre.actions').run_replace()<CR>",
                        desc = "replace all"
                    },
                    ['run_current_replace'] = {
                        map = "<c-j>",
                        cmd = "<cmd>lua require('spectre.actions').run_current_replace()<CR>",
                        desc = "replace current line"
                    },
                    ['tab'] = {
                        map = '<c-n>',
                        cmd = "<cmd>lua require('spectre').tab()<cr>",
                        desc = 'next query'
                    },
                    ['shift-tab'] = {
                        map = '<c-p>',
                        cmd = "<cmd>lua require('spectre').tab_shift()<cr>",
                        desc = 'previous query'
                    },
                    ['change_view_mode'] = {
                        map = "<tab",
                        cmd = "<cmd>lua require('spectre').change_view()<CR>",
                        desc = "change result view mode"
                    },
                    ['send_to_qf'] = {
                        map = "<nop>",
                        cmd = "<cmd>lua require('spectre.actions').send_to_qf()<CR>",
                        desc = "send all items to quickfix"
                    },
                    ['replace_cmd'] = {
                        map = "<leader>c",
                        cmd = "<cmd>lua require('spectre.actions').replace_cmd()<CR>",
                        desc = "input replace command"
                    },
                    ['show_option_menu'] = {
                        map = "<nop>",
                        cmd = "<cmd>lua require('spectre').show_options()<CR>",
                        desc = "show options"
                    },
                    ['change_replace_sed'] = {
                        map = "<nop>",
                        cmd = "<cmd>lua require('spectre').change_engine_replace('sed')<CR>",
                        desc = "use sed to replace"
                    },
                    ['change_replace_oxi'] = {
                        map = "<nop",
                        cmd = "<cmd>lua require('spectre').change_engine_replace('oxi')<CR>",
                        desc = "use oxi to replace"
                    },
                    ['toggle_live_update']={
                        map = "U",
                        cmd = "<cmd>lua require('spectre').toggle_live_update()<CR>",
                        desc = "update when vim writes to file"
                    },
                    ['toggle_ignore_case'] = {
                        map = "K",
                        cmd = "<cmd>lua require('spectre').change_options('ignore-case')<CR>",
                        desc = "toggle ignore case"
                    },
                    ['toggle_ignore_hidden'] = {
                        map = "H",
                        cmd = "<cmd>lua require('spectre').change_options('hidden')<CR>",
                        desc = "toggle search hidden"
                    },
                    ['resume_last_search'] = {
                        map = "L",
                        cmd = "<cmd>lua require('spectre').resume_last_search()<CR>",
                        desc = "repeat last search"
                    },
                },
            }
        )
    end
}
