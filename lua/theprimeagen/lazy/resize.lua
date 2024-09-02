return {
    "dimfred/resize-mode.nvim",
    config = function()
        require("resize-mode").setup {
            horizontal_amount = 9,
            vertical_amount = 5,
            quit_key = "<ESC>",
            enable_mapping = true,
            resize_keys = {
                "h", -- increase to the left
                "j", -- increase to the bottom
                "k", -- increase to the top
                "l", -- increase to the right
                "y", -- decrease to the left
                "u", -- decrease to the bottom
                "i", -- decrease to the top
                "o" -- decrease to the right
            },
            hooks = {
                on_enter = nil, -- called when entering resize mode
                on_leave = nil -- called when leaving resize mode
            }
        }
        vim.keymap.set('n','<C-w>u',require("resize-mode").start)
    end
}
