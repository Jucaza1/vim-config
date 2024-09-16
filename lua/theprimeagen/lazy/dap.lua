return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "leoluz/nvim-dap-go",
            'mfussenegger/nvim-dap-python',
            "rcarriga/nvim-dap-ui",
            "theHamsta/nvim-dap-virtual-text",
            "nvim-neotest/nvim-nio",
            "williamboman/mason.nvim",
        },
        config = function()
            local dap = require "dap"
            local ui = require "dapui"

            require("dapui").setup()
            require("dap-go").setup()
            require("dap-python").setup("~/.local/share/nvim/mason/packages/debugpy/venv/bin/python")
            require("nvim-dap-virtual-text").setup({
                -- This just tries to mitigate the chance that I leak tokens here. Probably won't stop it from happening...
                -- display_callback = function(variable)
                --   local name = string.lower(variable.name)
                --   local value = string.lower(variable.value)
                --   if name:match "secret" or name:match "api" or value:match "secret" or value:match "api" then
                --     return "*****"
                --   end
                --
                --   if #variable.value > 15 then
                --     return " " .. string.sub(variable.value, 1, 15) .. "... "
                --   end
                --
                --   return " " .. variable.value
                -- end,
            })
            require("dap-vscode-js").setup({
                -- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
                debugger_path = "~/.local/share/nvim/mason/packages/vscode-js-debug",
                -- debugger_cmd = { "extension" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
                adapters = { 'chrome', 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost', 'node', 'chrome' }, -- which adapters to register in nvim-dap
                -- log_file_path = "(stdpath cache)/dap_vscode_js.log" -- Path for file logging
                -- log_file_level = false -- Logging level for output to file. Set to false to disable file logging.
                -- log_console_level = vim.log.levels.ERROR -- Logging level for output to console. Set to false to disable console output.
            })
            local js_based_languages = { "typescript", "javascript", "typescriptreact" }

            for _, language in ipairs(js_based_languages) do
                dap.configurations[language] = {
                    {
                        type = "pwa-node",
                        request = "launch",
                        name = "Launch file",
                        program = "${file}",
                        cwd = "${workspaceFolder}",
                    },
                    {
                        type = "pwa-node",
                        request = "attach",
                        name = "Attach",
                        processId = require 'dap.utils'.pick_process,
                        cwd = "${workspaceFolder}",
                    },
                    {
                        type = "pwa-chrome",
                        request = "launch",
                        name = "Start Chrome with \"localhost\"",
                        url = "http://localhost:3000",
                        webRoot = "${workspaceFolder}",
                        userDataDir = "${workspaceFolder}/.vscode/vscode-chrome-debug-userdatadir"
                    }
                }
            end
            -- Handled by nvim-dap-go
            -- dap.adapters.go = {
            --   type = "server",
            --   port = "${port}",
            --   executable = {
            --     command = "dlv",
            --     args = { "dap", "-l", "127.0.0.1:${port}" },
            --   },
            -- }

            -- local elixir_ls_debugger = vim.fn.exepath "elixir-ls-debugger"
            -- if elixir_ls_debugger ~= "" then
            --     dap.adapters.mix_task = {
            --         type = "executable",
            --         command = elixir_ls_debugger,
            --     }
            --
            --     dap.configurations.elixir = {
            --         {
            --             type = "mix_task",
            --             name = "phoenix server",
            --             task = "phx.server",
            --             request = "launch",
            --             projectDir = "${workspaceFolder}",
            --             exitAfterTaskReturns = false,
            --             debugAutoInterpretAllModules = false,
            --         },
            --     }
            -- end
            -- dap.configurations.python = {
            --     {
            --         type = 'python',
            --         request = 'launch',
            --         name = "Launch file",
            --         program = "${file}",
            --         pythonPath = function()
            --             return '/usr/bin/python3'
            --         end,
            --     },
            -- }
            vim.keymap.set("n", "<space>b", dap.toggle_breakpoint)
            vim.keymap.set("n", "<space>gb", dap.run_to_cursor)

            -- Eval var under cursor
            vim.keymap.set("n", "<space>?", function()
                require("dapui").eval(nil, { enter = true })
            end)

            vim.keymap.set("n", "<F1>", dap.continue)
            vim.keymap.set("n", "<F2>", dap.step_into)
            vim.keymap.set("n", "<F3>", dap.step_over)
            vim.keymap.set("n", "<F4>", dap.step_out)
            vim.keymap.set("n", "<F5>", dap.step_back)
            vim.keymap.set("n", "<F9>", dap.restart)

            dap.listeners.before.attach.dapui_config = function()
                ui.open()
            end
            dap.listeners.before.launch.dapui_config = function()
                ui.open()
            end
            dap.listeners.before.event_terminated.dapui_config = function()
                ui.close()
            end
            dap.listeners.before.event_exited.dapui_config = function()
                ui.close()
            end
        end,
    },
}
