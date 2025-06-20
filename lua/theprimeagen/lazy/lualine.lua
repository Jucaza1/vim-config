return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons',
        "meuter/lualine-so-fancy.nvim" },
    config = function()
        local function maximize_status()
            return vim.t.maximized and '   ' or ''
        end
        local function keymap()
            if vim.opt.iminsert:get() > 0 and vim.b.keymap_name then
                return '⌨ ' .. vim.b.keymap_name
            end
            return ''
        end
        local options = {
            sections = {
                lualine_c = {
                    {
                        'filename',
                        file_status = true,     -- Displays file status (readonly status, modified status)
                        newfile_status = false, -- Display new file status (new file means no write after created)
                        path = 1,               -- 0: Just the filename
                        -- 1: Relative path
                        -- 2: Absolute path
                        -- 3: Absolute path, with tilde as the home directory
                        -- 4: Filename and parent dir, with tilde as the home directory

                        shorting_target = 40, -- Shortens path to leave 40 spaces in the window
                        -- for other components. (terrible name, any suggestions?)
                        symbols = {
                            modified = '[+]',      -- Text to show when the file is modified.
                            readonly = '[-]',      -- Text to show when the file is non-modifiable or readonly.
                            unnamed = '[No Name]', -- Text to show for unnamed buffers.
                            newfile = '[New]',     -- Text to show for newly created file before first write
                        },
                    },

                    maximize_status,
                },
                lualine_b = { { 'FugitiveHead', icon = '' }, { "fancy_diff" }, },
                lualine_x = { { "fancy_diagnostics" },
                    -- 'fancy_lsp_servers',
                    {
                        function()
                            local clients = vim.lsp.get_active_clients({ bufnr = 0 })
                            local names = {}
                            for _, client in ipairs(clients) do
                                if client.name ~= "GitHub Copilot" then
                                    table.insert(names, client.name)
                                end
                            end
                            return #names > 0 and "  " .. table.concat(names, ", ") or ""
                        end,
                    },
                    'encoding',
                    -- 'fileformat',
                    'filetype'
                },
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = { 'filename' },
                lualine_x = { 'location' },
                lualine_y = {},
                lualine_z = {}
            }
        }
        -- local comp1 = {
        --     require("noice").api.statusline.mode.get,
        --     cond = require("noice").api.statusline.mode.has,
        --     color = { fg = "#ff9e64" },
        -- }
        local comp2 = {
            keymap,

            color = { fg = "#ff9e64" },
        }
        -- table.insert(options.sections.lualine_x, comp1)
        table.insert(options.sections.lualine_x, comp2)
        require('lualine').setup(options)
    end
}
