-- UI and keymaps
local dap = require('dap')
local dapui = require('dapui')

local signs = {
    DapBreakpoint = {text='●', texthl='LspDiagnosticsDefaultError'},
    DapLogPoint = {text='◉', texthl='LspDiagnosticsDefaultError'},
    DapStopped = {text='🞂', texthl='LspDiagnosticsDefaultInformation', linehl='CursorLine'},
}
for sign, options in pairs(signs) do
    vim.fn.sign_define(sign, options)
end

local mappings = {
    ['<leader>dt' ] = dap.toggle_breakpoint,
    ['<leader>dj' ] = dap.continue,
    ['<leader>dn'] = dap.step_over,
    ['<leader>dl'] = dap.step_into,
    ['<leader>dh'] = dap.step_out,
}
for lhs, rhs in pairs(mappings) do
    vim.keymap.set('n', lhs, rhs, {silent = true})
end

-- dapui
-- Use nvim-dap events to open and close the ui windows automatically
dap.listeners.after['event_initialized']['dapui_config'] = function()
	dapui.open({})
end

dap.listeners.before['event_terminated']['dapui_config'] = function()
	dapui.close({})
end

dap.listeners.before['event_exited']['dapui_config'] = function()
	dapui.close({})
end

dapui.setup({
  mappings = {
    expand = { "<CR>", "<c-j>"},
    open = "o",
    remove = "d",
    edit = "e",
    repl = "r",
    toggle = "t",
  },
})
