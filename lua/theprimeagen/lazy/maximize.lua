return {
    'declancm/maximize.nvim',
    config = function()
        require('maximize').setup({})
        vim.keymap.set('n', '<leader>mm', "<CMD>lua require('maximize').toggle()<CR>")
    end
}
