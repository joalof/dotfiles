return {
    "monaqa/dial.nvim",
    keys = { "<C-a>", "<C-x>", "<leader>ae", "<leader>ax" },
    config = function()
        local augend = require("dial.augend")
        require("dial.config").augends:register_group({
            default = {
                augend.integer.alias.decimal,
                augend.integer.alias.hex,
                augend.date.alias["%Y/%m/%d"],
                augend.constant.new({
                    elements = { "true", "false" },
                    word = true,
                    cyclic = true,
                    preserve_case = true,
                }),
            },
        })
        vim.keymap.set("n", "<C-a>", require("dial.map").inc_normal())
        vim.keymap.set("n", "<C-x>", require("dial.map").dec_normal())
        vim.keymap.set("v", "<C-a>", require("dial.map").inc_visual())
        vim.keymap.set("v", "<C-x>", require("dial.map").dec_visual())

        -- local lsp = vim.lsp
        -- local ms = vim.lsp.protocol.Methods
        -- local util = vim.lsp.util
        --
        -- ---@type "a" | "b" | "c"
        -- local enum = "c"
        --
        -- ---@return lsp.CompletionItem[]
        -- local function get_lsp_items(params)
        --     local results = lsp.buf_request_sync(0, ms.textDocument_completion, params)
        --     local items = {}
        --     if results and not vim.tbl_isempty(results) then
        --         for _, obj in ipairs(results) do
        --             local result = obj.result
        --             if result then
        --                 items = vim.iter(result.items)
        --                     -- :filter(function(item)
        --                     --     return item.kind == lsp.protocol.CompletionItemKind.EnumMember
        --                     -- end)
        --                     :totable()
        --             end
        --
        --             if not vim.tbl_isempty(items) then
        --                 break
        --             end
        --         end
        --     end
        --     return items
        -- end
        --
        -- local function dial(inc)
        --     return function()
        --         local word = vim.fn.expand("<cWORD>")
        --         local params = util.make_position_params(0, "utf-8")
        --         local items = get_lsp_items(params)
        --
        --         if vim.tbl_isempty(items) then
        --             return
        --         end
        --
        --         local index
        --
        --         for i, value in ipairs(items) do
        --             if value.label == word then
        --                 index = i
        --                 break
        --             end
        --         end
        --
        --         if not index then
        --             return
        --         end
        --         if inc then
        --             index = index + 1
        --             if index > #items then
        --                 index = 1
        --             end
        --         else
        --             index = index - 1
        --             if index < 1 then
        --                 index = #items
        --             end
        --         end
        --
        --         local next_item = items[index]
        --
        --         local pos = vim.api.nvim_win_get_cursor(0)
        --
        --         vim.cmd("s/" .. word .. "/" .. next_item.label)
        --
        --         vim.api.nvim_win_set_cursor(0, pos)
        --     end
        -- end
        --
        -- vim.keymap.set("n", "<leader>ae", dial(true), { noremap = true })
        -- vim.keymap.set("n", "<leader>ax", dial(false), { noremap = true })

        -- vim.keymap.set("n", "<C-a>", function()
        --   if tonumber(vim.fn.expand("<cword>")) ~= nil then
        --     return "<C-a>"
        --   else
        --     return "<Plug>(LspDialInc)"
        --   end
        -- end, { expr = true })
        --
        -- vim.keymap.set("n", "<C-x>", function()
        --   if tonumber(vim.fn.expand("<cword>")) ~= nil then
        --     return "<C-x>"
        --   else
        --     return "<Plug>(LspDialDec)"
        --   end
        -- end, { expr = true })
    end,
}
