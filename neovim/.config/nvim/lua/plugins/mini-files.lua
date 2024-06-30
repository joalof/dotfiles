return {
    "echasnovski/mini.files",
    opts = {
        windows = {
            preview = true,
            width_focus = 30,
            width_preview = 30,
        },
        options = {
            -- Whether to use for editing directories
            -- Disabled by default in LazyVim because neo-tree is used for that
            use_as_default_explorer = true,
        },
    },
    keys = {
        {
            "<leader>fe",
            function()
                require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
            end,
            desc = "Open mini.files (directory of current file)",
        },
        -- {
        --     "<leader>fE",
        --     function()
        --         require("mini.files").open(vim.uv.cwd(), true)
        --     end,
        --     desc = "Open mini.files (cwd)",
        -- },
    },
    config = function(_, opts)
        
        MiniFiles = require('mini.files')
        MiniFiles.setup(opts)

        local show_dotfiles = true
        local filter_show = function(fs_entry)
            return true
        end
        local filter_hide = function(fs_entry)
            return not vim.startswith(fs_entry.name, ".")
        end

        local toggle_dotfiles = function()
            show_dotfiles = not show_dotfiles
            local new_filter = show_dotfiles and filter_show or filter_hide
            require("mini.files").refresh({ content = { filter = new_filter } })
        end

        local function go_in_cd()
            MiniFiles.go_in({ close_on_file = false })
            vim.cmd('cd %:p:h')
            -- vim.uv.chdir(vim.fn.expand('%:p:h'))
        end

        vim.api.nvim_create_autocmd("User", {
            pattern = "MiniFilesBufferCreate",
            callback = function(args)
                local buf_id = args.data.buf_id
                -- Tweak left-hand side of mapping to your liking
                vim.keymap.set("n", "g.", toggle_dotfiles, { buffer = buf_id })

                vim.keymap.set("n", "l", go_in_cd, { buffer = buf_id })
            end,
        })
    end,
}
