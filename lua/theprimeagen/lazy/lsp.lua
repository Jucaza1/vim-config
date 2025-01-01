return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "jay-babu/mason-nvim-dap.nvim",
        "williamboman/mason-lspconfig.nvim",
        "jay-babu/mason-null-ls.nvim",
        "nvimtools/none-ls.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
    },

    config = function()
        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities())
        local null_ls = require('null-ls')
        null_ls.setup()
        require("fidget").setup({})
        require("mason").setup()
        require("mason-nvim-dap").setup({
            ensure_installed = {
                "codelldb"
            }
        })
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                "rust_analyzer",
                "gopls",
                -- "ruff_lsp",
                "jsonls",
                "pyright",
                "eslint",
                "ts_ls",
                "zls",
                "jdtls",
            },
            handlers = {
                function(server_name) -- default handler (optional)
                    if server_name ~= "jdtls" then
                        require("lspconfig")[server_name].setup {
                            capabilities = capabilities
                        }
                    end
                    -- require("lspconfig")[server_name].setup {
                    --     capabilities = capabilities
                    -- }
                end,
                ["rust_analyzer"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.rust_analyzer.setup {
                        capabilities = capabilities,
                        settings = {
                            ['rust-analyzer'] = {
                                cargo = { allFeatures = true },
                                checkOnSave = { command = "clippy" },
                                diagnostics = {
                                    enable = true,
                                }
                            }
                        }
                    }
                end,

                zls = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.zls.setup({
                        root_dir = lspconfig.util.root_pattern(".git", "build.zig", "zls.json"),
                        settings = {
                            zls = {
                                enable_inlay_hints = true,
                                enable_snippets = true,
                                warn_style = true,
                            },
                        },
                    })
                    vim.g.zig_fmt_parse_errors = 0
                    vim.g.zig_fmt_autosave = 0
                end,
                ["lua_ls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.lua_ls.setup {
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                runtime = { version = "Lua 5.1" },
                                diagnostics = {
                                    globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
                                }
                            }
                        }
                    }
                end,
                ["phpactor"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.phpactor.setup({
                        root_dir = function(fname)
                            local root_files = { '.git', 'composer.json' }
                            local util = require('lspconfig/util')

                            return util.root_pattern(unpack(root_files))(fname) or
                                util.path.dirname(fname) -- Fallback to the file directory
                        end,
                        capabilities = capabilities,
                    })
                end,
                ["html"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.html.setup {
                        filetypes = { "html", "php" },
                        capabilities = capabilities,
                    }
                end,
                ["astro"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.astro.setup({
                        settings = {
                            astro = {
                                formatter = "prettier",
                                prettierPath = vim.fn.stdpath("data") .. "/mason/bin/prettier", -- Path to Mason's Prettier
                            },
                        },
                    })
                end
                -- ["htmx"] = function()
                --     local lspconfig = require("lspconfig")
                --     lspconfig.htmx.setup {
                --         capabilities = capabilities,
                --     }
                -- end,
            }
        })
        require("mason-null-ls").setup({
            ensure_installed = {
                -- 'stylua',
                -- 'jq',
                'black',
                'prettier',
                'gopls',
                'goimports',
                'phpcsfixer',
                'phpcbf'
            },
            handlers = {
                function() end, -- disables automatic setup of all null-ls sources
                gopls = function(source_name, methods)
                    null_ls.register(null_ls.builtins.formatting.gofmt)
                    null_ls.register(null_ls.builtins.formatting.goimports)
                end,
                prettier = function(source_name, methods)
                    -- null_ls.register(null_ls.builtins.formatting.prettier)
                    -- null_ls.builtins.formatting.prettier.with({ extra_args = { "--no-semi" } })
                    null_ls.builtins.formatting.prettier.with({
                        extra_args = { "--no-semi" },
                        filetypes = {
                            "javascript",
                            "typescript",
                            "css",
                            "scss",
                            "html",
                            -- "json",
                            -- "yaml",
                            "markdown",
                            -- "graphql",
                            "md",
                            "txt",
                            "astro",
                        },
                        -- only_local = "node_modules/.bin",
                        only_local = vim.fn.stdpath('data') .. '/mason/bin/prettier', -- Use Mason's Prettier
                        command = vim.fn.stdpath('data') .. '/mason/bin/prettier',    -- Use Mason's Prettier
                    })
                end,
                black = function(source_name, methods)
                    null_ls.register(null_ls.builtins.formatting.black)
                    -- null_ls.register(null_ls.builtins.formatting.black.with({ extra_args = { "--skip-string-normalization", } }))
                    --https://black.readthedocs.io/en/stable/usage_and_configuration/the_basics.html
                end,
                shfmt = function(source_name, methods)
                    -- custom logic
                    require('mason-null-ls').default_setup(source_name, methods) -- to maintain default behavior
                end,
                phpcbf = function(source_name, methods)
                    --     null_ls.register(null_ls.builtins.formatting.phpcbf)
                    null_ls.register(null_ls.builtins.formatting.phpcbf.with({
                        command = "phpcbf",     -- Make sure this is in your PATH
                        args = {
                            "--standard=PSR12", -- Specify the coding standard (PSR12 is commonly used)
                            "-"                 -- Read from stdin (this allows null-ls to format the buffer)
                        },
                    }))
                end,
            },
        })

        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                -- ['<Tab>'] = cmp.mapping.select_next_item(cmp_select),
                ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                -- ['<CR>'] = cmp.mapping.confirm({ select = true }),
                ['<C-e>'] = cmp.mapping.abort(),
                ["<C-Space>"] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' }, -- For luasnip users.
                { name = 'path' },
            }, {
                { name = 'buffer' },
            }),
            formatting = {
                fields = { 'menu', 'abbr', 'kind' },
                format = function(entry, item)
                    local menu_icon = {
                        nvim_lsp = 'λ',
                        luasnip = '⋗',
                        buffer = 'Ω',
                        path = '🖫',
                    }
                    item.menu = menu_icon[entry.source.name]
                    return item
                end,
            },
        })

        vim.diagnostic.config({
            update_in_insert = true,
            signs = {
                text = {
                    [vim.diagnostic.severity.ERROR] = "󰅚",
                    [vim.diagnostic.severity.WARN] = "󰀪",
                    [vim.diagnostic.severity.HINT] = "󰌶",
                    [vim.diagnostic.severity.INFO] = "",
                }
            },
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
                format = function(diagnostic)
                    if diagnostic.source == 'rustc'
                        and diagnostic.user_data.lsp.data ~= nil
                    then
                        return diagnostic.user_data.lsp.data.rendered
                    else
                        return diagnostic.message
                    end
                end,
            },
            loclist = {
                open = false,
            },
            qflist ={
                open = false,
            }
        })
        -- vim.diagnostic.setloclist({
        --     open = false, -- Don't automatically open the location list
        -- })
        -- vim.diagnostic.setqflist({
        --     open = false, -- Don't automatically open the location list
        -- })
        -- vim.diagnostic.handlers.loclist = {
        --     show = function(_, _, _, opts)
        --         -- Generally don't want it to open on every update
        --         opts.loclist.open = false
        --         local winid = vim.api.nvim_get_current_win()
        --         vim.diagnostic.setloclist(opts.loclist)
        --         vim.api.nvim_set_current_win(winid)
        --     end
        -- }
    end
}
