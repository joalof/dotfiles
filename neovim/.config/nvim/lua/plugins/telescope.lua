return {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.2",
    dependencies = {
        "nvim-lua/plenary.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        -- {"ahmedkhalf/project.nvim"},
    },
    cmd = "Telescope",
    keys = { "<leader>ff", "<leader>fn", "<leader>fh", "<leader>fg", "<leader>ff", "<leader>fa" },
    config = function()
        require("telescope").setup({
            defaults = {
                mappings = {
                    i = {
                        ["<C-j>"] = require("telescope.actions").select_default,
                        ["<C-c>"] = require("telescope.actions").close,
                    },
                    n = {
                        ["<C-j>"] = require("telescope.actions").select_default,
                        ["<C-c>"] = require("telescope.actions").close,
                    },
                },
            },
        })

        require("telescope").load_extension("fzf")

        local function get_git_root()
            local dot_git_path = vim.fn.finddir(".git", ".;")
            return vim.fn.fnamemodify(dot_git_path, ":h")
        end

        -- get the project root dir or fallback to cwd
        local function get_root_dir()
            -- local root = require('project_nvim.project').get_project_root()
            local root = get_git_root()
            if root ~= nil then
                return root
            else
                return vim.fn.getcwd()
            end
        end

        local builtin = require("telescope.builtin")
        vim.keymap.set("n", "<leader>ff", function()
            builtin.find_files({ cwd = get_root_dir() })
        end)
        vim.keymap.set("n", "<leader>fa", function()
            builtin.find_files({ cwd = "~" })
        end)
        vim.keymap.set("n", "<leader>fg", function()
            builtin.live_grep({ cwd = get_root_dir() })
        end)
        vim.keymap.set("n", "<leader>fh", builtin.help_tags)
        vim.keymap.set("n", "<leader>fn", function()
            builtin.find_files({ cwd = vim.fn.environ()["HOME"] .. "/.config/nvim", hidden = true })
        end)

        -- require('project_nvim').setup({})
        -- require('telescope').load_extension('projects')
        -- vim.keymap.set(
        --     'n',
        --     '<leader>fp',
        --     function() require('telescope').extensions.projects.projects() end
        -- )
    end,
}
