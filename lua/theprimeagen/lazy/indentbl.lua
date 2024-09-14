return {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    ---@module "ibl"
    ---@type ibl.config
    opts = {},
    config = function()
        local highlight = {
            "RainbowViolet",
            "RainbowCyan",
            "RainbowRed",
            "RainbowYellow",
            "RainbowBlue",
            "RainbowOrange",
            "RainbowGreen",
        }

        local hooks = require "ibl.hooks"
        hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
            vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
            vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
            vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
            vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
            vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
            vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
            vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
        end)
        require("ibl").setup({
            enabled = true,
            debounce = 200,
            viewport_buffer = {
                min = 30,
                max = 500,
            },
            indent = {
                char = "▎",
                --• left aligned solid
                --   • `▏`
                --   • `▎` (default)
                --   • `▍`
                --   • `▌`
                --   • `▋`
                --   • `▊`
                --   • `▉`
                --   • `█`
                -- • center aligned solid
                --   • `│`
                --   • `┃`
                -- • right aligned solid
                --   • `▕`
                --   • `▐`
                -- • center aligned dashed
                --   • `╎`
                --   • `╏`
                --   • `┆`
                --   • `┇`
                --   • `┊`
                --   • `┋`
                -- • center aligned double
                --   • `║`
                tab_char = nil,
                -- highlight = "IblIndent",
                highlight = highlight,
                smart_indent_cap = true,
                priority = 1,
                repeat_linebreak = true,
            },
            whitespace = {
                highlight = "IblWhitespace",
                remove_blankline_trail = true,
            },
            scope = {
                enabled = true,
                char = nil,
                -- show_start = true,
                show_start = false,
                -- show_end = true,
                show_end = false,
                show_exact_scope = false,
                injected_languages = true,
                highlight = "IblScope",
                priority = 1024,
                include = {
                    node_type = {},
                },
                exclude = {
                    language = {},
                    node_type = {
                        ["*"] = {
                            "source_file",
                            "program",
                        },
                        lua = {
                            "chunk",
                        },
                        python = {
                            "module",
                        },
                    },
                },
            },
            exclude = {
                filetypes = {
                    "lspinfo",
                    "packer",
                    "checkhealth",
                    "help",
                    "man",
                    "gitcommit",
                    "TelescopePrompt",
                    "TelescopeResults",
                    "",
                },
                buftypes = {
                    "terminal",
                    "nofile",
                    "quickfix",
                    "prompt",
                },
            },
        })
        -- vim.api.nvim_set_hl(0, "IblIndent", { fg = "#851491" })
    end
}
