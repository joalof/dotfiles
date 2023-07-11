return {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
      dependencies = {
          "nvim-treesitter/nvim-treesitter-textobjects",
          "nvim-treesitter/playground",
    },
    config = function()
        require('nvim-treesitter.configs').setup {
            ensure_installed = {
                'bash', 'c', 'cpp', 'json', 'lua', 'python', 'vim', 'yaml', 'regex', 'markdown', 'markdown_inline'
            },
            sync_install = false,
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },
            indent = {
                enable = true,
                disable = {"python"},
            },

            -- playground
            playground = {
                enable = false,
                disable = {},
            },

            textobjects = {
                select = {
                    enable = true,
                    -- Automatically jump forward to textobj, similar to targets.vim
                    lookahead = true,
                    keymaps = {
                        -- You can use the capture groups defined in textobjects.scm
                        ["af"] = "@function.outer",
                        ["if"] = "@function.inner",
                        ["ac"] = "@class.outer",
                        ["ic"] = "@class.inner",
                    },
                },
            },
        }
    end
}
