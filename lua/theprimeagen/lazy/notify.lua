return {
    "rcarriga/nvim-notify",
    opts = {
        timeout = 5000,
        background_colour = "#000000",
        render = "wrapped-compact",
    },
    config = function()
        require('notify').setup({
            timeout = 5000,
            background_colour = "#000000",
            render = "wrapped-compact",

        })
    end
}
