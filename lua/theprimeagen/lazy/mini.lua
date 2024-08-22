return {
    'echasnovski/mini.nvim',
    version = '*',
    config = function()
        require('mini.comment').setup() --gcc on normal, gc on visual, gc as textObject
        -- require('mini.completion').setup()
        require('mini.jump').setup() --repeat f,F,t,T after f<letter>
        require('mini.pairs').setup()
        require('mini.surround').setup() --sa add, sr replace, sd delete, sf sF find r/l surrounding

    end
}
