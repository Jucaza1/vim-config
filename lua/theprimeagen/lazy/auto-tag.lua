return {
        "windwp/nvim-ts-autotag", -- Tailwind-tools for type-sensitive tools
        config = function()
            require('nvim-ts-autotag').setup()
        end,
    }
