return {
    "waiting-for-dev/ergoterm.nvim",
    keys = { "<C-s>c", "<C-s>/", "<C-s>_", "<leader>ri" },
    dependencies = {
        "nvimtools/hydra.nvim",
        "carbon-steel/detour.nvim",
    },
    config = function()
        require("ergoterm").setup({})
        Color = require("lib.color").Color

        local terminal = require("ergoterm.terminal")

        -- Autocmd to apply when entering a terminal buffer
        -- vim.api.nvim_create_autocmd("TermOpen", {
        --     callback = function()
        --         local win = vim.api.nvim_get_current_win()
        --         local ns = vim.api.nvim_create_namespace("local_term_bg")
        --         -- get Normal background from global hl
        --         local normal = vim.api.nvim_get_hl(0, { name = "Normal" })
        --         local bg_darker = Color.from_css(normal.bg):shade(-0.65):to_css()
        --         vim.api.nvim_set_hl(ns, "Normal", { bg = bg_darker, fg = normal.fg })
        --         vim.api.nvim_win_set_hl_ns(win, ns)
        --     end,
        -- })
        
        -- keymaps to use nvim as multiplexer
        -- vim.keymap.set({ "n", "t" }, "<C-s>c", function()
        --     local term = terminal.Terminal:new({ layout = "tab" })
        --     term:focus()
        -- end)
        -- vim.keymap.set({ "n", "t" }, "<C-s>/", function()
        --     local term = terminal.Terminal:new({ layout = "right" })
        --     term:focus()
        --     -- local ns = vim.api.nvim_create_namespace("local_term_bg")
        --     -- local normal = vim.api.nvim_get_hl(0, { name = "Normal" })
        --     -- local bg_darker = Color.from_css(normal.bg):to_css()
        --     -- vim.api.nvim_win_set_hl_ns(term:get_state('window'), ns)
        --     -- vim.api.nvim_set_hl(ns, "Normal", { bg = bg_darker, fg = normal.fg })
        -- end)
        -- vim.keymap.set({ "n", "t" }, "<C-s>_", function()
        --     local term = terminal.Terminal:new({ layout = "below" })
        --     term:focus()
        -- end)

        -- hydra for tab navigation, not strictly related
        -- to terminals but I probably only want these keyamps
        -- if we're using nvims built-in terminal instead of
        -- terminal emulator multiplexing
        -- local hydra = require("hydra")
        -- hydra({
        --     name = "tab navigation",
        --     mode = { "n", "t" },
        --     body = "<C-s>",
        --     config = { hint = false },
        --     heads = {
        --         {
        --             "n",
        --             function()
        --                 vim.api.nvim_command("tabnext")
        --             end,
        --         },
        --         {
        --             "p",
        --             function()
        --                 vim.api.nvim_command("tabprevious")
        --             end,
        --         },
        --     },
        -- })

        vim.keymap.set("n", "<leader>ri", function()
            local popup_id = require("detour").Detour()
            if not popup_id then
                return
            end
            local filename = vim.api.nvim_buf_get_name(0)
            local cmd = "ipython --no-banner --no-confirm-exit"
            local term = terminal.Terminal:new({ cmd = cmd, layout = "window", close_on_job_exit = false })
            term:open()
            vim.cmd.startinsert() -- needed since ergoterm insert_on_start doesnt work with detour
            term:send({ string.format("run %s", filename) })
            vim.bo.bufhidden = "delete" -- close the terminal when window closes

            -- Skips the "[Process exited 0]" message from the embedded terminal
            vim.api.nvim_create_autocmd({ "TermClose" }, {
                buffer = vim.api.nvim_get_current_buf(),
                callback = function()
                    vim.api.nvim_feedkeys("i", "n", false)
                end,
            })
        end)
    end,
}
