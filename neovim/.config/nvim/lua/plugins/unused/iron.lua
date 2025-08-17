return {
    "Vigemus/iron.nvim",
    -- stylua: ignore
    keys = {
        { "<leader>ri" },
    -- { "gss", function() require("iron.core").send_line() end },
    -- { "gs", function() require("iron.core").run_motion("send_motion") end, mode={ "n" } },
    -- { "gs", function() require("iron.core").send_visual() end, mode={ "v" } },
    -- { "<leader>sc", function() require("iron.core").send_until_cursor() end },
    -- { "<leader>sf", function() require("iron.core").send_file() end },
    },
    config = function()
        require("iron.core").setup({
            config = {
                scratch_repl = true,
                repl_definition = {
                    python = { command = { "ipython" } },
                    r = { command = { "R" } },
                    julia = { command = { "julia" } },
                },
                repl_open_cmd = require("iron.view").split("20%"),
            },
        })
        vim.keymap.set("n", "<leader>ri", function()
            require("iron.core").send("python", "%reset -f")
            require("iron.core").send("python", string.format("run %s", vim.api.nvim_buf_get_name(0)))
        end)

        -- redefine keymaps s.t. they open the repl in no-neck-pain-right if it exists
        -- local ll = require("iron.lowlevel")
        -- local create_repl = function(ft, bufnr, current_bufnr, cleanup)
        --     local meta
        --     local success, repl = pcall(ll.get_repl_def, ft)
        --
        --     if not success and cleanup ~= nil then
        --         cleanup()
        --         error(repl)
        --     end
        --
        --     success, meta = pcall(ll.create_repl_on_current_window, ft, repl, bufnr, current_bufnr)
        --     if success then
        --         ll.set(ft, meta)
        --         return meta
        --     elseif cleanup ~= nil then
        --         cleanup()
        --     end
        --
        --     error(meta)
        -- end
    end,
}
