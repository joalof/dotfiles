return {
    'kevinhwang91/nvim-bqf',
    dependencies={
        {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'},
        {'junegunn/fzf', build = function() vim.fn['fzf#install']() end}
    },
    config = function()
    end
},

